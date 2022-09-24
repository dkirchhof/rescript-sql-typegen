open DB
open DDL.Create

let createArtistsTable = db => {
  let query = ArtistsTable.Create.makeQuery()->addPrimaryKey1("PK", c => c.id)

  Logger.log("create artists table", query->toSQL)

  query->execute(db)
}

let createAlbumsTable = db => {
  let query =
    AlbumsTable.Create.makeQuery()
    ->addPrimaryKey1("PK", c => c.id)
    ->addForeignKey("FK_Artist", c => c.artistId, ArtistsTable.table.columns.id, NO_ACTION, CASCADE)

  Logger.log("create albums table", query->toSQL)

  query->execute(db)
}

let createSongsTable = db => {
  let query =
    SongsTable.Create.makeQuery()
    ->addPrimaryKey1("PK", c => c.id)
    ->addForeignKey("FK_Album", c => c.albumId, AlbumsTable.table.columns.id, NO_ACTION, CASCADE)

  Logger.log("create songs table", query->toSQL)

  query->execute(db)
}
