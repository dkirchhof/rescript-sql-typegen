open QB

let log = (title, query) => {
  Js.log2(`\x1b[1m%s\x1b[0m`, title)
  Js.log(query->toSQL ++ ";")
  Js.log("")
}

let logAndExecute = (title, query, db) => {
  Js.log2(`\x1b[1m%s\x1b[0m`, title)
  Js.log(query->toSQL ++ ";")

  let result = execute(query, db)

  Js.log(result)
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

let db = SQLite3.createDB("db.db")

logAndExecute("get all artists:", Db.ArtistsTable.query, db)

logAndExecute(
  "get all artist names in alphabetic order:",
  Db.ArtistsTable.query
  ->orderBy(c => [OrderBy.asc(c.artist.name)])
  ->select(c => {"artist": {"name": c.artist.name}}),
  db,
)

logAndExecute(
  "get number of songs:",
  Db.SongsTable.query->select(_ => {"song": {"count": countAll()}}),
  db,
)

logAndExecute(
  "get albums of year 1982 or 1992 (OR):",
  Db.AlbumsTable.query->where(c =>
    Expr.or_([Expr.eq(c.album.year, value(1982)), Expr.eq(c.album.year, value(1992))])
  ),
  db,
)

/* log( */
/* "get albums of year 1982 or 1992 (IN):", */
/* Db.AlbumsTable.query->where(c => Expr.in_(c.album.year, [value(1982), value(1992)])), */
/* ) */

/* log( */
/* "get all artists with it's albums with it's songs:", */
/* Db.ArtistsLeftJoinAlbumsLeftJoinSongs.query */
/* ->join(0, c => Expr.eq(c.al.artistId, c.ar.id)) */
/* ->join(1, c => Expr.eq(c.s.albumId, c.al.id)), */
/* ) */

/* log( */
/* "get all albums with songs (exclude empty albums):", */
/* Db.AlbumsInnerJoinSongs.query->join(0, c => Expr.eq(c.s.albumId, c.a.id)), */
/* ) */

/* log( */
/* "get all albums which are newer than 'Fear of the Dark' (join):", */
/* Db.AlbumsInnerJoinAlbums.query */
/* ->join(0, c => Expr.eq(c.a2.name, value("Fear of the Dark"))) */
/* ->where(c => Expr.gt(c.a1.year, c.a2.year)), */
/* ) */

/* /1* log( *1/ */
/* /1* "get all albums which are newer than 'Fear of the Dark' (subquery):", *1/ */
/* /1* from(Db.AlbumsTable.t, "a") *1/ */
/* /1* ->where((a, _, _) => *1/ */
/* /1* Expr.gt( *1/ */
/* /1* a.year, *1/ */
/* /1* subQuery( *1/ */
/* /1* from(Db.AlbumsTable.t, "a") *1/ */
/* /1* ->where((a, _, _) => Expr.eq(a.name, value("Fear of the Dark"))) *1/ */
/* /1* ->select((a, _, _) => a.year), *1/ */
/* /1* ), *1/ */
/* /1* ) *1/ */
/* /1* ) *1/ */
/* /1* ->select((a, _, _) => a.name), *1/ */
/* /1* ) *1/ */

/* let avgDurationQuery = Db.SongsTable.query->select(c => avg(c.song.duration)) */

/* log("get avg song duration:", avgDurationQuery) */

/* /1* log( *1/ */
/* /1* "get all songs which are longer then the avg:", *1/ */
/* /1* Db.Songs.query *1/ */
/* /1* ->where(c => Expr.gt(c.s.duration, subQuery(avgDurationQuery))) *1/ */
/* /1* ->select(c => (c.s.id, c.s.name, c.s.duration)), *1/ */
/* /1* ) *1/ */

/* log( */
/* "get songs with duration between 1 and 2 minutes:", */
/* Db.SongsTable.query->where(c => Expr.btw(c.song.duration, value("1:00"), value("2:00"))), */
/* ) */

/* log( */
/* "get number of albums per artist:", */
/* Db.ArtistsLeftJoinAlbums.query */
/* ->join(0, c => Expr.eq(c.al.artistId, c.ar.id)) */
/* ->groupBy(c => [GroupBy.group(c.al.artistId)]) */
/* ->select(c => (c.ar.name, count(c.al.id))), */
/* ) */

/* log( */
/* "get number of albums per artist (but only artists with less than 4 albums):", */
/* Db.ArtistsLeftJoinAlbums.query */
/* ->join(0, c => Expr.eq(c.al.artistId, c.ar.id)) */
/* ->groupBy(c => [GroupBy.group(c.al.artistId)]) */
/* ->having(c => Expr.lt(count(c.al.id), value(4))) */
/* ->select(c => (c.ar.name, count(c.al.id))), */
/* ) */

/* /1* let aas = *1/ */
/* /1*   Db.ArtistsLeftJoinAlbumsLeftJoinSongs.query *1/ */
/* /1*   ->join(0, c => Expr.eq(c.al.artistId, c.ar.id)) *1/ */
/* /1*   ->join(1, c => Expr.eq(c.s.albumId, c.al.id)) *1/ */
/* /1*   ->execute(db) *1/ */

/* /1* open! JsArray2Ex *1/ */

/* /1* aas *1/ */
/* /1* ->groupBy(row => row.ar) *1/ */
/* /1* ->map(((artist, rows)) => *1/ */
/* /1*   { *1/ */
/* /1*     "artist": artist.name, *1/ */
/* /1*     "albums": rows *1/ */
/* /1*     ->groupBy(row => row.al) *1/ */
/* /1*     ->map(((album, rows2)) => {"album": album.name, "songs": rows2->map(row => row.s.name)}), *1/ */
/* /1*   } *1/ */
/* /1* ) *1/ */
/* /1* ->inspect *1/ */
