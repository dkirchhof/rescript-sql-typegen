external conv: (unit => string) => 'a = "%identity"

let c: Schema.column<'a> => 'a = column => {
  Ref.ColumnRef(ColumnRef.make(column))->Obj.magic
}

let v: 'a => 'a = value => {
  Ref.ValueRef(ValueRef.make(value))->Obj.magic
}

let s: SubQuery.t<'a> => 'a = subQuery => {
  conv(() => QueryRef.toSQL(subQuery))
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

/* // get all artists */
/* QB.from(Db.ArtistsTable.t)->QB1.toSQL->Js.log */

/* // get album names and years of year 1982 or 1992 */
/* QB.from(Db.AlbumsTable.t) */
/* ->QB1.where(a => Expr.or_([Expr.eq(c2(a.year), v2(1982)), Expr.eq(c2(a.year), v2(1992))])) */
/* ->QB1.select(a => (c(a.name), c(a.year))) */
/* ->QB1.toSQL */
/* ->Js.log */

/* // get all artists with all albums with songs */
/* QB.from(Db.ArtistsTable.t) */
/* ->QB1.leftJoin(Db.AlbumsTable.t, (ar, al) => Expr.eq(c2(al.artistId), c2(ar.id))) */
/* ->QB2.leftJoin(Db.SongsTable.t, (_ar, al, s) => Expr.eq(c2(s.albumId), c2(al.id))) */
/* ->QB3.toSQL */
/* ->Js.log */

/* // get all album names with song names (exclude empty albums) */
/* QB.from(Db.AlbumsTable.t) */
/* ->QB1.innerJoin(Db.SongsTable.t, (a, s) => Expr.eq(c2(s.albumId), c2(a.id))) */
/* ->QB2.select((a, s) => (c(a.name), c(s.name))) */
/* ->QB2.toSQL */
/* ->Js.log */

/* // get all albums which are newer than "Fear of the Dark" (join) */
/* QB.from(Db.AlbumsTable.t) */
/* ->QB1.innerJoin(Db.AlbumsTable.t, (_a1, a2) => Expr.eq(c2(a2.name), v2("Fear of the Dark"))) */
/* ->QB2.where((a1, a2) => Expr.gt(c2(a1.year), c2(a2.year))) */
/* ->QB2.toSQL */
/* ->Js.log */

/* // get all albums which are newer than "Fear of the Dark" (subquery) */
/* let yearOfFearOfTheDarkQuery = */
/*   QB.from(Db.AlbumsTable.t) */
/*   ->QB1.select(a => c(a.year)) */
/*   ->QB1.where(a => Expr.eq(c2(a.name), v2("Fear of the Dark"))) */

/* QB.from(Db.AlbumsTable.t) */
/* ->QB1.where(a => Expr.gt(c2(a.year), s2(QB1.asSubQuery(yearOfFearOfTheDarkQuery)))) */
/* ->QB1.toSQL */
/* ->Js.log */

/* /1* /2* // get avg song duration *2/ *1/ */
/* /1* /2* QB.from(Db.SongsTable.t) *2/ *1/ */
/* /1* /2* /3* ->QB1.select(s => column(s.duration)) *3/ *2/ *1/ */
/* /1* /2* /3* ->QB1.select(s => Agg.avg(s.id)) *3/ *2/ *1/ */
/* /1* /2* ->QB1.select(s => Agg.avg(1)) *2/ *1/ */
/* /1* /2* ->QB1.toSQL *2/ *1/ */
/* /1* /2* ->Js.log *2/ *1/ */

/* /1* /2* // get all songs which are longer then the avg *2/ *1/ */


Js.log("##############################")

let test = QB_MANY.from(Db.ArtistsTable.t, "artist")
->QB_MANY.leftJoin1(Db.AlbumsTable.t, "album", (ar, al, _) => Expr.eq(c2(al.artistId), c2(ar.id)))
->QB_MANY.leftJoin2(Db.SongsTable.t, "song", (_ar, al, s) => Expr.eq(c2(s.albumId), c2(al.id)))
->QB_MANY.select((ar, al, s) => (c(ar.name), c(al.name), c(s.name)))

/* test->Utils.inspect */
test->QB_MANY.toSQL->Js.log
