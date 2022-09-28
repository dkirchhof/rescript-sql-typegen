let get: Provider.get<_, _> = (sql, connection) => {
  let getRows = queryResult => Js.Promise.resolve(fst(queryResult))

  connection->MySQL2.query(sql)->Js.Promise.then_(getRows, _)
}

let mutate: Provider.mutate<_> = (sql, connection) => {
  open MySQL2

  connection
  ->MySQL2.mutate(sql)
  ->Js.Promise.then_(
    result =>
      Provider.makeMutationResult(
        ~changes=result.affectedRows,
        ~lastId=result.insertId,
      )->Js.Promise.resolve,
    _,
  )
}
