rethink = require 'rethinkdb'
{split, merge, curry, tail} = require 'ramda'
{parse} = require 'url'

getConnectionOptions = (url) =>
  {hostname, port, path, auth} = parse url
  options =
    host: hostname
    port: port
    db: (tail path) || 'test'
  if auth
    [user, password] = split ':', auth
    merge options, {user, password}
  else
    options


module.exports = (url) =>
  options = getConnectionOptions url
  connect = (options) => rethink.connect options
  _run = (query) =>
    connect(options)
      .then (conn) =>
        query.run conn
          .then (res) ->
            conn.close()
            res

  run: _run
  toArray: (query) => _run(query).then (cur) => cur.toArray()
  each: curry (fn, query) => _run(query).then (cur) => cur.each fn
  eachAsync: curry ( fn, query) => _run(query).then (cur) => cur.eachAsync fn
