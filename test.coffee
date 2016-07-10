test = require 'tape'
sinon = require 'sinon'
{any} = require 'ramda'
db = require('./dist') 'rethink://admin:password@localhost:28015/test'
r = require 'rethinkdb'


test 'run should execure a query', (t) ->
  t.plan 1
  db.run r.table('test').insert({msg: 'test'})
  .then (res) =>
    t.equals(res.inserted, 1)

test 'toArray should return an array of results', (t) ->
  t.plan 1
  db.toArray r.table('test')
  .then (results) =>
    t.equals (any (({msg}) -> msg == 'test'), results), true

test 'each should call the funciton for each result', (t) ->
  t.plan 1
  spy = sinon.spy()
  db.each spy, r.table('test').changes()

  db.run r.table('test').insert({msg: 'each test'})
    .then (results) =>
      t.equals spy.calledOnce, true
