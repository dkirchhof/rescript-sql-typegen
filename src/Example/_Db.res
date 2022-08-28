open CodeGen

let artistsTable: Table.t = {
  moduleName: "ArtistsTable",
  tableName: "artists",
  defaultTableAlias: "artist",
  columns: [
    { name: "id", dt: Integer },
    { name: "name", dt: String },
  ],
}

printTableModule(artistsTable)
Js.log("")

let albumsTable: Table.t = {
  moduleName: "AlbumsTable",
  tableName: "albums",
  defaultTableAlias: "album",
  columns: [
    { name: "id", dt: Integer },
    { name: "artistId", dt: Integer },
    { name: "name", dt: String },
    { name: "year", dt: Integer },
  ],
}

printTableModule(albumsTable)
Js.log("")

let songsTable: Table.t = {
  moduleName: "SongsTable",
  tableName: "songs",
  defaultTableAlias: "song",
  columns: [
    { name: "id", dt: Integer },
    { name: "albumId", dt: Integer },
    { name: "name", dt: String },
    { name: "duration", dt: String },
  ],
}

printTableModule(songsTable)
Js.log("")

printJoinModule("AlbumsInnerJoinSongs", albumsTable, [Join.Inner(songsTable)])
