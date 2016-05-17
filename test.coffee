{toArray, run} = require('./dist') 'rethink://192.168.99.100:28015/test'
r = require 'rethinkdb'

run r.table('test').insert({msg: 'test'})
.then () =>
  toArray r.table('test')
    .then (res) => console.log 'res', res
    .catch (err) => console.log 'err', err
