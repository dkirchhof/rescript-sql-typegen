type connection

type connectionOptions = {
  host: string,
  user: string,
  password: string,
  database: string,
}

type columnDefinition

type resultSetHeader = {
  fieldCount: int,
  affectedRows: int,
  insertId: int,
  info: string,
  serverStatus: int,
  warningStatus: int,
}

type queryResult<'a> = (array<Js.Dict.t<'a>>, array<columnDefinition>)

@module("mysql2/promise")
external createConnection: connectionOptions => promise<connection> = "createConnection"

@send
external query: (connection, string) => promise<_> = "query"

@send
external end: connection => promise<unit> = "end"
