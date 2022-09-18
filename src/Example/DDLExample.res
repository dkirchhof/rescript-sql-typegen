open DB
open DDL.Create

let createArtistsTable = db => {
  let query = ArtistsTable.Create.makeQuery()

  Logger.log("create artists table", query->toSQL)

  query->execute(db)
}

let createAlbumsTable = db => {
  let query = AlbumsTable.Create.makeQuery()

  Logger.log("create albums table", query->toSQL)

  query->execute(db)
}

let createSongsTable = db => {
  let query = SongsTable.Create.makeQuery()

  Logger.log("create songs table", query->toSQL)

  query->execute(db)
}
