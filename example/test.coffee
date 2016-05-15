rethink = require '../'

db = rethink 'http://192.168.99.100:32771'


db.all 'logs'
  .then (logs) => console.log 'LOGS', logs
  .catch (error) => console.log 'ERROR', error
