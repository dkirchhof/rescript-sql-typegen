open CodeGen
open Zora

zora("create table", t => {
  let artistsTable: Table.t = {
    moduleName: "ArtistsTable",
    tableName: "artists",
    columns: [{name: "id", dt: Integer}, {name: "name", dt: String}],
  }

  /* printTableModule(artistsTable) */

  /* t->equal(sql, result, "") */

  done()
})
