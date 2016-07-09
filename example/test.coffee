rethink = require '../'

db = rethink 'http://192.168.99.100:32771'


db.run r.table('logs').insert log
  .then (logs) => console.log 'LOG', logs
  .catch (error) => console.log 'ERROR', error
