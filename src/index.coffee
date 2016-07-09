rethink = require 'rethinkdb'
{curry, tail} = require 'ramda'
{parse} = require 'url'
parseUrl = (url) =>
  {hostname, port, path} = parse url
  {host: hostname, port, db: (tail path) || 'test'}

module.exports = (url) =>
  options = parseUrl url
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
