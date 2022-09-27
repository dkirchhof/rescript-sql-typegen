open CodeGen

let artistsTable: Table.t = {
  moduleName: "ArtistsTable",
  tableName: "artists",
  columns: [
    {name: "id", dt: Integer, autoIncrement: true, skipInInsertQuery: true},
    {name: "name", dt: Varchar, size: 100, unique: true},
  ],
}

makeTableModule(artistsTable)->Js.log
Js.log("")

let albumsTable: Table.t = {
  moduleName: "AlbumsTable",
  tableName: "albums",
  columns: [
    {name: "id", dt: Integer, autoIncrement: true, skipInInsertQuery: true},
    {name: "artistId", dt: Integer},
    {name: "name", size: 100, dt: Varchar},
    {name: "year", dt: Integer},
  ],
}

makeTableModule(albumsTable)->Js.log
Js.log("")

let songsTable: Table.t = {
  moduleName: "SongsTable",
  tableName: "songs",
  columns: [
    {name: "id", dt: Integer, autoIncrement: true, skipInInsertQuery: true},
    {name: "albumId", dt: Integer},
    {name: "name", size: 100, dt: Varchar},
    {name: "duration", size: 10, dt: Varchar},
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
