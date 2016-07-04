#oolon-rethink

makes it simple to run queries on rethink.db

##why?
Rethinkdb is great! Their query language is awesome, but their nodejs driver is a little awkward to use.

rethink driver example:
```
const usersPromise = r.connect({host, port, path})
  .then((connection) => {
    return r
      .table('users')
      .run(connection)
      .then((cursor) => cursor.toArray())
  })
```

oolon-rethink wrap the rethinkdb cursor commands, so running queries is much easier:

```
const db = oolonRethink(rethinkUrl)
const usersPromise = db.toArray(r.table('users'))
```

This approach has several benefits.

1. your db code is much simpler to write and read.
2. oolon-rethink handles the database connection so you don't have to
3. oolon-rethink handles all the side effects and async code, so you can focus on writing and testing pure functions


## Usage

```
import r from 'rethinkdb'
import rethink from 'oolon-rethink'

const db = rethink('localhost:28015')

db.toArray(r.table('users'))
db.each(func, r.table('users'))
db.eachAsync(func, r.table('users'))
db.run(r.table('users').insert({name: 'brian'}))
```
