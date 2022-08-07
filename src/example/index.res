external conv: (unit => string) => 'a = "%identity"

let c: Schema.column<'a> => 'a = column => {
  Ref.ColumnRef(ColumnRef.make(column))->Obj.magic
}

let v: 'a => 'a = value => {
  Ref.ValueRef(ValueRef.make(value))->Obj.magic
}

let s: SubQuery.t<'a> => 'a = subQuery => {
  Ref.QueryRef(QueryRef.make(subQuery))->Obj.magic
}

let c2: Schema.column<'a> => Ref.t2<'a> = column => {
  Ref.ColumnRef(ColumnRef.make(column))->Obj.magic
}

let v2: 'a => Ref.t2<'a> = value => {
  Ref.ValueRef(ValueRef.make(value))->Obj.magic
}

let s2: SubQuery.t<'a> => Ref.t2<'a> = subQuery => {
  Ref.QueryRef(QueryRef.make(subQuery))->Obj.magic
}

let asc: Schema.column<'a> => OrderBy.t = column => {
  open OrderBy

  {column: ColumnRef.make(column), direction: ASC}
}

let desc: Schema.column<'a> => OrderBy.t = column => {
  open OrderBy

  {column: ColumnRef.make(column), direction: DESC}
}

let group: Schema.column<'a> => GroupBy.t = column => {
  ColumnRef.make(column)
}

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
  ->orderBy((a, _, _) => [asc(a.name)])
  ->select((a, _, _) => (c(a.id), c(a.name))),
)

log(
  "get album names and years of year 1982 or 1992:",
  from(Db.AlbumsTable.t, "a")
  ->where((a, _, _) => Expr.or_([Expr.eq(c2(a.year), v2(1982)), Expr.eq(c2(a.year), v2(1992))]))
  ->select((a, _, _) => (c(a.name), c(a.year))),
)

log(
  "get all artists with it's albums with it's songs:",
  from(Db.ArtistsTable.t, "artist")
  ->leftJoin1(Db.AlbumsTable.t, "album", (ar, al, _s) => Expr.eq(c2(al.artistId), c2(ar.id)))
  ->leftJoin2(Db.SongsTable.t, "song", (_ar, al, s) => Expr.eq(c2(s.albumId), c2(al.id)))
  ->select((ar, al, s) => (c(ar.name), c(al.name), c(s.name))),
)

log(
  "get all album names with song names (exclude empty albums):",
  from(Db.AlbumsTable.t, "a")
  ->innerJoin1(Db.SongsTable.t, "s", (a, s, _) => Expr.eq(c2(s.albumId), c2(a.id)))
  ->select((a, s, _) => (c(a.name), c(s.name))),
)

log(
  "get all albums which are newer than 'Fear of the Dark' (join):",
  from(Db.AlbumsTable.t, "a1")
  ->innerJoin1(Db.AlbumsTable.t, "a2", (_, a2, _) => Expr.eq(c2(a2.name), v2("Fear of the Dark")))
  ->where((a1, a2, _) => Expr.gt(c2(a1.year), c2(a2.year)))
  ->select((a1, _, _) => c(a1.name)),
)

log(
  "get all albums which are newer than 'Fear of the Dark' (subquery):",
  from(Db.AlbumsTable.t, "a")
  ->where((a, _, _) =>
    Expr.gt(
      c2(a.year),
      s2(
        from(Db.AlbumsTable.t, "a")
        ->where((a, _, _) => Expr.eq(c2(a.name), v2("Fear of the Dark")))
        ->select((a, _, _) => c(a.year))
        ->asSubQuery,
      ),
    )
  )
  ->select((a, _, _) => c(a.name)),
)

/* // get avg song duration */
/* QB.from(Db.SongsTable.t) */
/* /1* ->QB1.select(s => column(s.duration)) *1/ */
/* /1* ->QB1.select(s => Agg.avg(s.id)) *1/ */
/* ->QB1.select(s => Agg.avg(1)) */
/* ->QB1.toSQL */
/* ->Js.log */

/* // get all songs which are longer then the avg */
