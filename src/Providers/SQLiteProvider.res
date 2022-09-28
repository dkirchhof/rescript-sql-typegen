let get: Provider.get<_, _> = (sql, connection) => {
  connection->SQLite3.prepare(sql)->SQLite3.query->Js.Promise.resolve
}

let mutate: Provider.mutate<_> = (sql, connection) => {
  let result = connection->SQLite3.prepare(sql)->SQLite3.mutate

  Provider.makeMutationResult(
    ~changes=result.changes,
    ~lastId=result.lastInsertRowId,
  )->Js.Promise.resolve
}
