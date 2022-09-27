let get = (sql, connection) => {
  connection->SQLite3.prepare(sql)->SQLite3.all->Js.Promise.resolve
}

let execute = (sql, connection) => {
  connection->SQLite3.prepare(sql)->SQLite3.run->Js.Promise.resolve
}
