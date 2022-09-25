open DB
open DDL.Create

let createArtistsTable = (exec, connection) => {
  let query = ArtistsTable.Create.makeQuery()->addPrimaryKey1("PK", c => c.id)

  Logger.log("create artists table", query->toSQL)

  query->execute(exec, connection)
}

let createAlbumsTable = (exec, connection) => {
  let query =
    AlbumsTable.Create.makeQuery()
    ->addPrimaryKey1("PK", c => c.id)
    ->addForeignKey("FK_Artist", c => c.artistId, ArtistsTable.table.columns.id, NO_ACTION, CASCADE)

  Logger.log("create albums table", query->toSQL)

  query->execute(exec, connection)
}

let createSongsTable = (exec, connection) => {
  let query =
    SongsTable.Create.makeQuery()
    ->addPrimaryKey1("PK", c => c.id)
    ->addForeignKey("FK_Album", c => c.albumId, AlbumsTable.table.columns.id, NO_ACTION, CASCADE)

  Logger.log("create songs table", query->toSQL)

  query->execute(exec, connection)
}
