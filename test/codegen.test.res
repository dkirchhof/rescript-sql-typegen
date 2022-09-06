open CodeGen
open Test

let equal = (a: 't, b: 't) => assertion((a, b) => a === b, a, b)

test("create table module", () => {
  let artistsTable: Table.t = {
    moduleName: "ArtistsTable",
    tableName: "artists",
    columns: [{name: "id", dt: Integer}, {name: "name", dt: String, size: 255, unique: true}],
  }

  let result = makeTableModule(artistsTable)

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

test("create select query module", () => {
  let artistsTable: Table.t = {
    moduleName: "ArtistsTable",
    tableName: "artists",
    columns: [{name: "id", dt: Integer}, {name: "name", dt: String, unique: true}],
  }

  let result = makeSelectQueryModule("Artists", artistsTable, "artist", [])

  open StringBuilder

  let code =
    make()
    ->addS(`module Artists = {`)
    ->addS(`  type selectables = {`)
    ->addS(`    artist: ArtistsTable.columns,`)
    ->addS(`  }`)
    ->addE
    ->addS(`  type projectables = {`)
    ->addS(`    artist: ArtistsTable.columns,`)
    ->addS(`  }`)
    ->addE
    ->addS(`  let makeSelectQuery = (): Query.t<projectables, selectables, _> => {`)
    ->addS(`    let from = From.make("artists", "artist")`)
    ->addE
    ->addS(`    let joins = [`)
    ->addS(`    ]`)
    ->addE
    ->addS(`    Query.makeSelectQuery(from, joins)->QB.select(c =>`)
    ->addS(`      {`)
    ->addS(`        "artist": {`)
    ->addS(`          "id": c.artist.id->QB.columnU,`)
    ->addS(`          "name": c.artist.name->QB.columnU,`)
    ->addS(`        },`)
    ->addS(`      }`)
    ->addS(`    )`)
    ->addS(`  }`)
    ->addS(`}`)
    ->build

  equal(result, code)
})
