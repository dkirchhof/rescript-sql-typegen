open DB

let createArtistsTable = (exec, connection) => {
  open DDL.Create

  let query = ArtistsTable.Create.makeQuery()->addPrimaryKey1("PK", c => c.id)

  Logger.log("create artists table", query->toSQL)

  query->execute(exec, connection)
}

let createAlbumsTable = (exec, connection) => {
  open DDL.Create

  let query =
    AlbumsTable.Create.makeQuery()
    ->addPrimaryKey1("PK", c => c.id)
    ->addForeignKey("FK_Artist", c => c.artistId, ArtistsTable.table.columns.id, NO_ACTION, CASCADE)

  Logger.log("create albums table", query->toSQL)

  query->execute(exec, connection)
}

let createSongsTable = (exec, connection) => {
  open DDL.Create

  let query =
    SongsTable.Create.makeQuery()
    ->addPrimaryKey1("PK", c => c.id)
    ->addForeignKey("FK_Album", c => c.albumId, AlbumsTable.table.columns.id, NO_ACTION, CASCADE)

  Logger.log("create songs table", query->toSQL)

  query->execute(exec, connection)
}

let dropArtistsTable = (exec, connection) => {
  open DDL.Drop

  let query = ArtistsTable.Drop.makeQuery()

  Logger.log("drop artists table", query->toSQL)

  query->execute(exec, connection)
}

let dropAlbumsTable = (exec, connection) => {
  open DDL.Drop

  let query = AlbumsTable.Drop.makeQuery()

  Logger.log("drop albums table", query->toSQL)

  query->execute(exec, connection)
}

let dropSongsTable = (exec, connection) => {
  open DDL.Drop

  let query = SongsTable.Drop.makeQuery()

  Logger.log("drop songs table", query->toSQL)

  query->execute(exec, connection)
}
