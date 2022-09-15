open DB
open DML.Insert

Logger.log("insert", ArtistsTable.Insert.makeQuery([{name: "Test"}, {name: "fsdf"}])->toSQL)
