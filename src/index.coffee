rethink = require 'rethinkdb'
{curry, tail} = require 'ramda'
{parse} = require 'url'
parseUrl = (url) =>
  {hostname, port, path} = parse url
  {host: hostname, port, db: (tail path) || 'test'}

module.exports = (url) =>
  connectionPromise = rethink.connect parseUrl url
  _run = (query) => connectionPromise.then (conn) => query.run conn

  run: _run
  toArray: (query) => _run(query).then (cur) => cur.toArray()
  each: curry (fn, query) => _run(query).then (cur) => cur.each fn
  eachAsync: curry ( fn, query) => _run(query).then (cur) => cur.eachAsync fn
  each: curry (fn, query) => _run(query).then (cur) => cur.each fn
