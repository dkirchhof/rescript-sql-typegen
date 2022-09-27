let get = (sql, connection) => {
  let getRows = queryResult => Js.Promise.resolve(fst(queryResult))

  (connection->MySQL2.query(sql)->Js.Promise.then_(getRows, _) :> promise<array<Js.Dict.t<_>>>)
}

let execute = (sql, connection) => {
  (connection->MySQL2.query(sql) :> Js.Promise.t<MySQL2.resultSetHeader>)
}
