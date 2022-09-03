open CodeGen

let artistsTable: Table.t = {
  moduleName: "ArtistsTable",
  tableName: "artists",
  columns: [{name: "id", dt: Integer}, {name: "name", dt: String}],
}

createTableModule(artistsTable)->Js.log
Js.log("")

let albumsTable: Table.t = {
  moduleName: "AlbumsTable",
  tableName: "albums",
  columns: [
    {name: "id", dt: Integer},
    {name: "artistId", dt: Integer},
    {name: "name", dt: String},
    {name: "year", dt: Integer},
  ],
}

printTableModule(albumsTable)
Js.log("")

let songsTable: Table.t = {
  moduleName: "SongsTable",
  tableName: "songs",
  columns: [
    {name: "id", dt: Integer},
    {name: "albumId", dt: Integer},
    {name: "name", dt: String},
    {name: "duration", dt: String},
  ],
}

printTableModule(songsTable)
Js.log("")

printSelectQueryModule("Artists", artistsTable, "artist", [])
Js.log("")

printSelectQueryModule("Albums", albumsTable, "album", [])
Js.log("")

printSelectQueryModule("Songs", songsTable, "song", [])
Js.log("")

printSelectQueryModule(
  "AlbumsInnerJoinSongs",
  albumsTable,
  "album",
  [innerJoin(songsTable, "song")],
)
Js.log("")

printSelectQueryModule("AlbumsInnerJoinAlbums", albumsTable, "a1", [innerJoin(albumsTable, "a2")])
Js.log("")

printSelectQueryModule(
  "ArtistsLeftJoinAlbums",
  artistsTable,
  "artist",
  [leftJoin(albumsTable, "album")],
)
Js.log("")

printSelectQueryModule(
  "ArtistsLeftJoinAlbumsLeftJoinSongs",
  artistsTable,
  "artist",
  [leftJoin(albumsTable, "album"), leftJoin(songsTable, "song")],
)
