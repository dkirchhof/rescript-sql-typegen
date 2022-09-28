type connection
type statement

type queryResult<'a> = array<Js.Dict.t<'a>>
type mutationResult = {changes: int, lastInsertRowId: int}

@new @module("better-sqlite3") external createConnection: string => connection = "default"

@send external prepare: (connection, string) => statement = "prepare"
@send external query: statement => queryResult<_> = "all"
@send external mutate: statement => mutationResult = "run"
