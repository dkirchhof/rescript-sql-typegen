type connection

type connectionOptions = {
  host: string,
  user: string,
  password: string,
  database: string,
}

type columnDefinition

type queryResult<'a> = (array<Js.Dict.t<'a>>, array<columnDefinition>)

type mutateResult = {
  fieldCount: int,
  affectedRows: int,
  insertId: int,
  info: string,
  serverStatus: int,
  warningStatus: int,
}

@module("mysql2/promise")
external createConnection: connectionOptions => promise<connection> = "createConnection"

@send
external query: (connection, string) => promise<queryResult<_>> = "query"

@send
external mutate: (connection, string) => promise<mutateResult> = "query"

@send
external end: connection => promise<unit> = "end"
