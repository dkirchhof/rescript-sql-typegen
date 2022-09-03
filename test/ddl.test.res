open DDL
open Test

let equal = (a: 't, b: 't) => assertion((a, b) => a === b, a, b)

test("create table query", () => {
  let result =
    createTable(Db.ArtistsTable.table)
    ->primaryKey(c => PrimaryKey.make1("PK_Artist", c.id))
    ->foreignKeys(c => [
      ForeignKey.make("FK_ArtistId", c.id, Db.ArtistsTable.table.columns.id),
      ForeignKey.make("FK_ArtistName", c.name, Db.ArtistsTable.table.columns.name),
    ])
    ->toSQL

  let sql = [
    "CREATE TABLE artists (",
    "  id INTEGER NOT NULL,",
    "  name TEXT(255) NOT NULL UNIQUE DEFAULT 'test',",
    "  CONSTRAINT PK_Artist PRIMARY KEY(id),",
    "  CONSTRAINT FK_ArtistId (id) REFERENCES artists(id),",
    "  CONSTRAINT FK_ArtistName (name) REFERENCES artists(name)",
    ")",
  ]->Js.Array2.joinWith("\n")

  equal(result, sql)
})
