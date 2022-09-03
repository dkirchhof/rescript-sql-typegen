open CodeGen
open Test

let equal = (a: 't, b: 't) => assertion((a, b) => a === b, a, b)

test("create table module", () => {
  let artistsTable: Table.t = {
    moduleName: "ArtistsTable",
    tableName: "artists",
    columns: [{name: "id", dt: Integer}, {name: "name", dt: String, size: 255, unique: true}],
  }

  let result = createTableModule(artistsTable)

  open StringBuilder

  let code =
    make()
    ->addS(`module ArtistsTable = {`)
    ->addS(`  type columns = {`)
    ->addS(`    id: DDL.Column.t<int>,`)
    ->addS(`    name: DDL.Column.t<string>,`)
    ->addS(`  }`)
    ->addE
    ->addS(`  type optionalColumns = {`)
    ->addS(`    id: DDL.Column.t<option<int>>,`)
    ->addS(`    name: DDL.Column.t<option<string>>,`)
    ->addS(`  }`)
    ->addE
    ->addS(`  let table: DDL.Table.t<columns> = {`)
    ->addS(`    name: "artists",`)
    ->addS(`    columns: {`)
    ->addS(`      id: {`)
    ->addS(`        table: "artists",`)
    ->addS(`        name: "id",`)
    ->addS(`        dt: "INTEGER",`)
    ->addS(`        size: None,`)
    ->addS(`        nullable: false,`)
    ->addS(`        unique: false,`)
    ->addS(`        default: None,`)
    ->addS(`      },`)
    ->addS(`      name: {`)
    ->addS(`        table: "artists",`)
    ->addS(`        name: "name",`)
    ->addS(`        dt: "TEXT",`)
    ->addS(`        size: Some(255),`)
    ->addS(`        nullable: false,`)
    ->addS(`        unique: true,`)
    ->addS(`        default: None,`)
    ->addS(`      },`)
    ->addS(`    },`)
    ->addS(`  }`)
    ->addS(`}`)
    ->build

  equal(result, code)
})
