open DB
open DDL

/* createTable(ArtistsTable.table) */
/* ->primaryKey(c => PrimaryKey.make1("PK_Artist", c.id)) */
/* ->toSQL */
/* ->Js.log */

/* Js.log("") */

/* createTable(AlbumsTable.table) */
/* ->primaryKey(c => PrimaryKey.make1("PK_Album", c.id)) */
/* ->foreignKeys(c => [ */
/* ForeignKey.make("FK_AlbumArtist", c.artistId, ArtistsTable.table.columns.id), */
/* ]) */
/* ->toSQL */
/* ->Js.log */

/* Js.log("") */

/* createTable(SongsTable.table) */
/* ->primaryKey(c => PrimaryKey.make1("PK_Song", c.id)) */
/* ->foreignKeys(c => [ */
/* ForeignKey.make("FK_SongAlbum", c.albumId, AlbumsTable.table.columns.id), */
/* ]) */
/* ->toSQL */
/* ->Js.log */

ArtistsTable.Create.makeQuery()->toSQL->Js.log
