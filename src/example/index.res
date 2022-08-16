open QB

let log = (title, query) => {
  Js.log2(`\x1b[1m%s\x1b[0m`, title)
  Js.log(query->toSQL ++ ";")
  Js.log("")
}

%%raw(`
  import { inspect as inspect_ } from "util";
`)

let inspect = %raw(`
  function(value) {
    console.log(inspect_(value, false, 10, true));
  }
`)

/* log( */
/* "get all artists ordered by name:", */
/* from(Db.ArtistsTable.t, "a") */
/* ->orderBy((a, _, _) => [OrderBy.asc(a.name)]) */
/* ->select((_, _, _) => all()), */
/* ) */

log(
  "get all artists ordered by name:",
  Db.ArtistsTable.query
  ->orderBy(c => [OrderBy.asc(c.artists.name)])
  ->select(c => (c.artists.id, c.artists.name)),
)

log("get number of songs 1:", Db.SongsTable.query->select(_ => count(all())))

log("get number of songs 2:", Db.SongsTable.query->select(_ => countAll()))

log(
  "get album names and years of year 1982 or 1992 (OR):",
  Db.AlbumsTable.query
  ->where(c => Expr.or_([Expr.eq(c.albums.year, value(1982)), Expr.eq(c.albums.year, value(1992))]))
  ->select(c => (c.albums.name, c.albums.year)),
)

log(
  "get album names and years of year 1982 or 1992 (IN):",
  Db.AlbumsTable.query
  ->where(c => Expr.in_(c.albums.year, [value(1982), value(1992)]))
  ->select(c => (c.albums.name, c.albums.year)),
)

log(
  "get all artists with it's albums with it's songs:",
  Db.ArtistsLeftJoinAlbumsLeftJoinSongs.query
  ->join(0, c => Expr.eq(c.al.artistId, c.ar.id))
  ->join(1, c => Expr.eq(c.s.albumId, c.al.id))
  ->select(c => (c.ar.name, c.al.name, c.s.name)),
)

log(
  "get all album names with song names (exclude empty albums):",
  Db.AlbumsInnerJoinSongs.query
  ->join(0, c => Expr.eq(c.s.albumId, c.a.id))
  ->select(c => (c.a.name, c.s.name)),
)

log(
  "get all albums which are newer than 'Fear of the Dark' (join):",
  Db.AlbumsInnerJoinAlbums.query
  ->join(0, c => Expr.eq(c.a2.name, value("Fear of the Dark")))
  ->where(c => Expr.gt(c.a1.year, c.a2.year))
  ->select(c => c.a1.name),
)

/* log( */
/* "get all albums which are newer than 'Fear of the Dark' (subquery):", */
/* from(Db.AlbumsTable.t, "a") */
/* ->where((a, _, _) => */
/* Expr.gt( */
/* a.year, */
/* subQuery( */
/* from(Db.AlbumsTable.t, "a") */
/* ->where((a, _, _) => Expr.eq(a.name, value("Fear of the Dark"))) */
/* ->select((a, _, _) => a.year), */
/* ), */
/* ) */
/* ) */
/* ->select((a, _, _) => a.name), */
/* ) */

let avgDurationQuery = Db.SongsTable.query->select(c => avg(c.songs.duration))

log("get avg song duration:", avgDurationQuery)

/* log( */
/* "get all songs which are longer then the avg:", */
/* Db.Songs.query */
/* ->where(c => Expr.gt(c.s.duration, subQuery(avgDurationQuery))) */
/* ->select(c => (c.s.id, c.s.name, c.s.duration)), */
/* ) */

log(
  "get songs with duration between 1 and 2 minutes:",
  Db.SongsTable.query
  ->where(c => Expr.btw(c.songs.duration, value("1:00"), value("2:00")))
  ->select(_ => all()),
)

log(
  "get number of albums per artist:",
  Db.ArtistsLeftJoinAlbums.query
  ->join(0, c => Expr.eq(c.al.artistId, c.ar.id))
  ->groupBy(c => [GroupBy.group(c.al.artistId)])
  ->select(c => (c.ar.name, count(c.al.id))),
)

log(
  "get number of albums per artist (less than 4 albums):",
  Db.ArtistsLeftJoinAlbums.query
  ->join(0, c => Expr.eq(c.al.artistId, c.ar.id))
  ->groupBy(c => [GroupBy.group(c.al.artistId)])
  ->having(c => Expr.lt(count(c.al.id), value(4)))
  ->select(c => (c.ar.name, count(c.al.id))),
)
