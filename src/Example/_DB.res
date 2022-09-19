open CodeGen

let artistsTable: Table.t = {
  moduleName: "ArtistsTable",
  tableName: "artists",
  columns: [
    {name: "id", dt: Integer, skipInInsertQuery: true},
    {name: "name", dt: String, unique: true},
  ],
  constraints: [primaryKey("PK", ["id"])],
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
  constraints: [
    primaryKey("PK", ["id"]),
    foreignKey("FK_Artist", "artistId", artistsTable.moduleName, "id"),
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
  constraints: [
    primaryKey("PK", ["id"]),
    foreignKey("FK_Album", "albumId", albumsTable.moduleName, "id"),
  ],
}

makeTableModule(songsTable)->Js.log
Js.log("")

makeSelectQueryModule("Artists", artistsTable, "artist", [])->Js.log
Js.log("")

makeSelectQueryModule("Albums", albumsTable, "album", [])->Js.log
Js.log("")

makeSelectQueryModule("Songs", songsTable, "song", [])->Js.log
Js.log("")

makeSelectQueryModule(
  "AlbumsInnerJoinSongs",
  albumsTable,
  "album",
  [innerJoin(songsTable, "song")],
)->Js.log
Js.log("")

makeSelectQueryModule(
  "AlbumsInnerJoinAlbums",
  albumsTable,
  "a1",
  [innerJoin(albumsTable, "a2")],
)->Js.log
Js.log("")

makeSelectQueryModule(
  "ArtistsLeftJoinAlbums",
  artistsTable,
  "artist",
  [leftJoin(albumsTable, "album")],
)->Js.log
Js.log("")

makeSelectQueryModule(
  "ArtistsLeftJoinAlbumsLeftJoinSongs",
  artistsTable,
  "artist",
  [leftJoin(albumsTable, "album"), leftJoin(songsTable, "song")],
)->Js.log
