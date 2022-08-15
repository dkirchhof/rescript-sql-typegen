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
  from(Db.ArtistsTable.t, "a")
  ->orderBy((a, _, _) => [OrderBy.asc(a.name)])
  ->select((a, _, _) => (a.id, a.name)),
)

/* log("get number of songs:", from(Db.SongsTable.t, "s")->select((_, _, _) => count(all()))) */

log("get number of songs:", from(Db.SongsTable.t, "s")->select((_, _, _) => countAll()))

log(
  "get album names and years of year 1982 or 1992 (OR):",
  from(Db.AlbumsTable.t, "a")
  ->where((a, _, _) => Expr.or_([Expr.eq(a.year, value(1982)), Expr.eq(a.year, value(1992))]))
  ->select((a, _, _) => (a.name, a.year)),
)

log(
  "get album names and years of year 1982 or 1992 (IN):",
  from(Db.AlbumsTable.t, "a")
  ->where((a, _, _) => Expr.in_(a.year, [value(1982), value(1992)]))
  ->select((a, _, _) => (a.name, a.year)),
)

log(
  "get all artists with it's albums with it's songs:",
  from(Db.ArtistsTable.t, "artist")
  ->leftJoin1(Db.AlbumsTable.t, "album", (ar, al, _s) => Expr.eq(al.artistId, ar.id))
  ->leftJoin2(Db.SongsTable.t, "song", (_ar, al, s) => Expr.eq(s.albumId, al.id))
  ->select((ar, al, s) => (ar.name, al.name, s.name)),
)

log(
  "get all album names with song names (exclude empty albums):",
  from(Db.AlbumsTable.t, "a")
  ->innerJoin1(Db.SongsTable.t, "s", (a, s, _) => Expr.eq(s.albumId, a.id))
  ->select((a, s, _) => (a.name, s.name)),
)

log(
  "get all albums which are newer than 'Fear of the Dark' (join):",
  from(Db.AlbumsTable.t, "a1")
  ->innerJoin1(Db.AlbumsTable.t, "a2", (_, a2, _) => Expr.eq(a2.name, value("Fear of the Dark")))
  ->where((a1, a2, _) => Expr.gt(a1.year, a2.year))
  ->select((a1, _, _) => a1.name),
)

log(
  "get all albums which are newer than 'Fear of the Dark' (subquery):",
  from(Db.AlbumsTable.t, "a")
  ->where((a, _, _) =>
    Expr.gt(
      a.year,
      subQuery(
        from(Db.AlbumsTable.t, "a")
        ->where((a, _, _) => Expr.eq(a.name, value("Fear of the Dark")))
        ->select((a, _, _) => a.year),
      ),
    )
  )
  ->select((a, _, _) => a.name),
)

let avgDurationQuery = from(Db.SongsTable.t, "s")->select((s, _, _) => avg(s.duration))

log("get avg song duration:", avgDurationQuery)

log(
  "get all songs which are longer then the avg:",
  from(Db.SongsTable.t, "song")
  ->where((s, _, _) => Expr.gt(s.duration, subQuery(avgDurationQuery)))
  ->select((s, _, _) => (s.id, s.name, s.duration)),
)

log(
  "get songs with duration between 1 and 2 minutes:",
  from(Db.SongsTable.t, "song")
  ->where((s, _, _) => Expr.btw(s.duration, value("1:00"), value("2:00")))
  ->select((_, _, _) => all()),
)

log(
  "get number of albums per artist:",
  from(Db.ArtistsTable.t, "ar")
  ->leftJoin1(Db.AlbumsTable.t, "al", (ar, al, _) => Expr.eq(al.artistId, ar.id))
  ->groupBy((_, al, _) => [GroupBy.group(al.artistId)])
  ->select((ar, al, _) => (ar.name, count(al.id))),
)

log(
  "get number of albums per artist (less than 4 albums):",
  from(Db.ArtistsTable.t, "ar")
  ->leftJoin1(Db.AlbumsTable.t, "al", (ar, al, _) => Expr.eq(al.artistId, ar.id))
  ->groupBy((_, al, _) => [GroupBy.group(al.artistId)])
  ->having((_, al, _) => Expr.lt(count(al.id), value(4)))
  ->select((ar, al, _) => (ar.name, count(al.id))),
)
