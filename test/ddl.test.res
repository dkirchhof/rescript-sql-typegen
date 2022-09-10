/* open DB */
/* open DDL */
/* open Test */

/* let equal = (a: 't, b: 't) => assertion((a, b) => a === b, a, b) */

/* test("create table query", () => { */
/*   let result = */
/*     createTable(AlbumsTable.table) */
/*     ->primaryKey(c => PrimaryKey.make1("PK_Album", c.id)) */
/*     ->foreignKeys(c => [ */
/*       ForeignKey.make("FK_AlbumArtist", c.artistId, ArtistsTable.table.columns.id), */
/*     ]) */
/*     ->toSQL */

/*   open StringBuilder */

/*   let sql = */
/*     make() */
/*     ->addS("CREATE TABLE albums (") */
/*     ->addS("  id INTEGER NOT NULL,") */
/*     ->addS("  artistId INTEGER NOT NULL,") */
/*     ->addS("  name TEXT NOT NULL,") */
/*     ->addS("  year INTEGER NOT NULL,") */
/*     ->addS("  CONSTRAINT PK_Album PRIMARY KEY (id),") */
/*     ->addS("  CONSTRAINT FK_AlbumArtist FOREIGN KEY (artistId) REFERENCES artists(id)") */
/*     ->addS(")") */
/*     ->build */

/*   equal(result, sql) */
/* }) */
