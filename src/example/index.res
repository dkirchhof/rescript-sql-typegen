// get all artists
QB.from(Db.ArtistsTable.t)->QB1.toSQL->Js.log

// get album names and years of year 1982 or 1992
QB.from(Db.AlbumsTable.t)
->QB1.where(a => Expr.or_([Expr.eqV(a.year, 1982), Expr.eqV(a.year, 1992)]))
->QB1.select(a => (a.name, a.year))
->QB1.toSQL
->Js.log

// get all artists with all albums with songs
QB.from(Db.ArtistsTable.t)
->QB1.leftJoin(Db.AlbumsTable.t, al => al.artistId, ar => ar.id)
->QB2.leftJoin(Db.SongsTable.t, s => s.albumId, (_ar, al) => al.id)
->QB3.toSQL
->Js.log

// get all album names with song names (exclude empty albums)
QB.from(Db.AlbumsTable.t)
->QB1.innerJoin(Db.SongsTable.t, s => s.albumId, a => a.id)
->QB2.select((a, s) => (a.name, s.name))
->QB2.toSQL
->Js.log

// get all albums which are newer than "Fear of the Dark" (join)
/* QB.from(Db.AlbumsTable.t) */
/* ->QB1.innerJoin(Db.AlbumsTable.t, (_a1, a2) => Expr.eqV(a2.name, "Fear of the Dark")) */
/* ->QB1.where(a => Expr.gtS(a.year, QB2.asSubQuery(yearOfFearOfTheDarkQuery))) */
/* ->QB1.toSQL */
/* ->Js.log */

// get all albums which are newer than "Fear of the Dark" (subquery)
let yearOfFearOfTheDarkQuery =
  QB.from(Db.AlbumsTable.t)
  ->QB1.select(a => a.year)
  ->QB1.where(a => Expr.eqV(a.name, "Fear of the Dark"))
  ->QB1.leftJoin(Db.SongsTable.t, s => s.id, a => a.id)

QB.from(Db.AlbumsTable.t)
->QB1.where(a => Expr.gtS(a.year, QB2.asSubQuery(yearOfFearOfTheDarkQuery)))
->QB1.toSQL
->Js.log

// get avg song duration
// get all songs which are longer then the avg
