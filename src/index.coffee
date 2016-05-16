rethink = require 'rethinkdb'
{parse: parseUrl} = require 'url'
{curry, tail} = require 'ramda'

toArray = (query) =>
  query.then (cursor) => cursor.toArray()

changes = curry (table, conn) =>
  rethink.table(table).changes().run(conn)

all = curry (table, conn) =>
  toArray rethink.table(table).limit(50).run(conn)

insert = curry (table, doc, conn) =>
  rethink.table(table).insert(doc).run(conn)

getAll = curry (table, ids, conn) =>
  toArray rethink.table(table).getAll(ids).run(conn)

filter = curry (table, filter, conn) =>
  toArray rethink.table(table).filter(filter).run(conn)

module.exports = (url) =>
  {hostname, port, path} = parseUrl url

  connection = rethink.connect host:hostname, port:port, db: (tail path) || 'test'
    .catch (err) =>
      console.error 'CONNECTION ERROR', err
      process.exit 1

  all: (table) => connection.then (all table)
  changes: (table) => connection.then (changes table)
  insert: curry (table, doc) => connection.then (insert table, doc)
  getAll: curry (table, ids) => connection.then (getAll table, ids)
  filter: curry (table, filter) => connection.then (filter table, filter)
