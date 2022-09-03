open DDL
open Zora

zora("create table", t => {
  let sql =
    createTable(Db.ArtistsTable.table)
    ->primaryKey(c => PrimaryKey.make1("PK_Artist", c.id))
    ->foreignKeys(c => [
      ForeignKey.make("FK_ArtistId", c.id, Db.ArtistsTable.table.columns.id),
      ForeignKey.make("FK_ArtistName", c.name, Db.ArtistsTable.table.columns.name),
    ])
    ->toSQL

  let result = [
    "CREATE TABLE artists (",
    "  id INTEGER NOT NULL,",
    "  name TEXT(255) NOT NULL UNIQUE DEFAULT 'test',",
    "  CONSTRAINT PK_Artist PRIMARY KEY(id),",
    "  CONSTRAINT FK_ArtistId (id) REFERENCES aritsts(id),",
    "  CONSTRAINT FK_ArtistName (name) REFERENCES aritsts(name)",
    ")",
  ]->Js.Array2.joinWith("\n")

  t->equal(sql, result, "")

  done()
})
