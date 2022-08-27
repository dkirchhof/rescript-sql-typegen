type db
type statement

@new @module("better-sqlite3") external createDB: string => db = "default"

@send external prepare: (db, string) => statement = "prepare"
@send external raw: (statement, bool) => statement = "raw"
@send external all: statement => QueryResult.t<'a> = "all"
