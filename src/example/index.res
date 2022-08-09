external conv: (unit => string) => 'a = "%identity"

open QB_MANY
open QB_TEST

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

log(
  "get all artists ordered by name:",
  from(Db.ArtistsTable.t, "a")
  ->where((a, _, _) => Expr.eq(c(a.id), v(1)))
  ->orderBy((a, _, _) => [OrderBy.asc(c(a.name))])
  ->groupBy((a, _, _) => [GroupBy.group(c(a.id))])
  ->select((a, _, _) => (count(a.id), c(a.id), c(a.name))),
)

log(
  "get all artists ordered by name:",
  from(Db.ArtistsTable.t, "a")
  ->orderBy((a, _, _) => [OrderBy.asc(a.name)])
  ->select((a, _, _) => (c(a.id), c(a.name))),
)

log("get number of songs:", from(Db.SongsTable.t, "s")->select((s, _, _) => count(s.id)))

log(
  "get album names and years of year 1982 or 1992:",
  from(Db.AlbumsTable.t, "a")
  ->where((a, _, _) => Expr.or_([Expr.eq(c(a.year), v(1982)), Expr.eq(c(a.year), v(1992))]))
  ->select((a, _, _) => (c(a.name), c(a.year))),
)

log(
  "get all artists with it's albums with it's songs:",
  from(Db.ArtistsTable.t, "artist")
  ->leftJoin1(Db.AlbumsTable.t, "album", (ar, al, _s) => Expr.eq(c(al.artistId), c(ar.id)))
  ->leftJoin2(Db.SongsTable.t, "song", (_ar, al, s) => Expr.eq(c(s.albumId), c(al.id)))
  ->select((ar, al, s) => (c(ar.name), c(al.name), c(s.name))),
)

log(
  "get all album names with song names (exclude empty albums):",
  from(Db.AlbumsTable.t, "a")
  ->innerJoin1(Db.SongsTable.t, "s", (a, s, _) => Expr.eq(c(s.albumId), c(a.id)))
  ->select((a, s, _) => (c(a.name), c(s.name))),
)

log(
  "get all albums which are newer than 'Fear of the Dark' (join):",
  from(Db.AlbumsTable.t, "a1")
  ->innerJoin1(Db.AlbumsTable.t, "a2", (_, a2, _) => Expr.eq(c(a2.name), v("Fear of the Dark")))
  ->where((a1, a2, _) => Expr.gt(c(a1.year), c(a2.year)))
  ->select((a1, _, _) => c(a1.name)),
)

/* log( */
/* "get all albums which are newer than 'Fear of the Dark' (subquery):", */
/* from(Db.AlbumsTable.t, "a") */
/* ->where((a, _, _) => */
/* Expr.gt( */
/* c(a.year), */
/* s( */
/* from(Db.AlbumsTable.t, "a") */
/* ->where((a, _, _) => Expr.eq(c(a.name), v("Fear of the Dark"))) */
/* ->select((a, _, _) => c(a.year)) */
/* ->asSubQuery, */
/* ), */
/* ) */
/* ) */
/* ->select((a, _, _) => c(a.name)), */
/* ) */

log("get avg song duration:", from(Db.SongsTable.t, "s")->select((s, _, _) => avg(s.duration)))

/* /1* // get all songs which are longer then the avg *1/ */
