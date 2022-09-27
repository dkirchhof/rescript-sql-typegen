type connection
type statement
type result = {changes: int, lastInsertRowId: int}

@new @module("better-sqlite3") external createConnection: string => connection = "default"

@send external prepare: (connection, string) => statement = "prepare"
@send external all: statement => array<Js.Dict.t<_>> = "all"
@send external run: statement => result = "run"
