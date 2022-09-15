open DB
open DML.Insert

let db = SQLite3.createDB(":memory:")

Logger.log("insert", ArtistsTable.Insert.makeQuery([{name: "Test"}, {name: "fsdf"}])->toSQL)

/* ArtistsTable.Insert.makeQuery([{name: "Test"}, {name: "fsdf"}])->execute(db)->Js.log */
