open CodeGen

let artistsTable: Table.t = {
  moduleName: "ArtistsTable",
  tableName: "artists",
  columns: [
    {name: "id", dt: Integer, skipInInsertQuery: true},
    {name: "name", dt: String, unique: true},
  ],
}

makeTableModule(artistsTable)->Js.log
Js.log("")

let albumsTable: Table.t = {
  moduleName: "AlbumsTable",
  tableName: "albums",
  columns: [
    {name: "id", dt: Integer, skipInInsertQuery: true},
    {name: "artistId", dt: Integer},
    {name: "name", dt: String},
    {name: "year", dt: Integer},
  ],
}

makeTableModule(albumsTable)->Js.log
Js.log("")

let songsTable: Table.t = {
  moduleName: "SongsTable",
  tableName: "songs",
  columns: [
    {name: "id", dt: Integer, skipInInsertQuery: true},
    {name: "albumId", dt: Integer},
    {name: "name", dt: String},
    {name: "duration", dt: String},
  ],
}

makeTableModule(songsTable)->Js.log
Js.log("")

makeJoinQueryModule(
  "ArtistsLeftJoinAlbums",
  from(artistsTable, "artist"),
  [leftJoin(albumsTable, "album")],
)->Js.log
Js.log("")

makeJoinQueryModule(
  "ArtistsLeftJoinAlbumsLeftJoinSongs",
  from(artistsTable, "artist"),
  [leftJoin(albumsTable, "album"), leftJoin(songsTable, "song")],
)->Js.log
