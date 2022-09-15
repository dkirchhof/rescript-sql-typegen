open DB
open DDL.Create

let db = SQLite3.createDB(":memory:")

Logger.log("create", ArtistsTable.Create.makeQuery()->toSQL)

ArtistsTable.Create.makeQuery()->execute(db)->Js.log
