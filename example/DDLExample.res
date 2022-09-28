open DB

let createArtistsTable = (mutate, connection) => {
  open DDL.Create

  let query = ArtistsTable.Create.makeQuery()->addPrimaryKey1("PK", c => c.id)

  Logger.log("create artists table", query->toSQL)

  query->execute(mutate, connection)
}

let createAlbumsTable = (mutate, connection) => {
  open DDL.Create

  let query =
    AlbumsTable.Create.makeQuery()
    ->addPrimaryKey1("PK", c => c.id)
    ->addForeignKey("FK_Artist", c => c.artistId, ArtistsTable.table.columns.id, NO_ACTION, CASCADE)

  Logger.log("create albums table", query->toSQL)

  query->execute(mutate, connection)
}

let createSongsTable = (mutate, connection) => {
  open DDL.Create

  let query =
    SongsTable.Create.makeQuery()
    ->addPrimaryKey1("PK", c => c.id)
    ->addForeignKey("FK_Album", c => c.albumId, AlbumsTable.table.columns.id, NO_ACTION, CASCADE)

  Logger.log("create songs table", query->toSQL)

  query->execute(mutate, connection)
}

let dropArtistsTable = (mutate, connection) => {
  open DDL.Drop

  let query = ArtistsTable.Drop.makeQuery()

  Logger.log("drop artists table", query->toSQL)

  query->execute(mutate, connection)
}

let dropAlbumsTable = (mutate, connection) => {
  open DDL.Drop

  let query = AlbumsTable.Drop.makeQuery()

  Logger.log("drop albums table", query->toSQL)

  query->execute(mutate, connection)
}

let dropSongsTable = (mutate, connection) => {
  open DDL.Drop

  let query = SongsTable.Drop.makeQuery()

  Logger.log("drop songs table", query->toSQL)

  query->execute(mutate, connection)
}
