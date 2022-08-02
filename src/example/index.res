/* let r1 = */
/*   QB.from(Db.ArtistsTable.t) */
/*   ->QB1.where(t => */
/*     Expr.and_([ */
/*       Expr.eqV(t.id, 1), */ 
/*       Expr.or_([ */
/*         Expr.eqC(t.name, t.name), Expr.eqV(t.name, "test") */
/*       ]) */
/*     ]) */
/*   ) */
/*   ->QB1.select(t => (t.id, t.name)) */

/* r1->QB1.toSQL->Js.log */

/* let r2 = */
/*   r1 */
/*   ->QB1.innerJoin(Db.AlbumsTable.t) */
/*   ->QB2.where(((ar, al)) => Expr.eqC(ar.id, al.id)) */
/*   ->QB2.select(((ar, al)) => (ar.name, al.name)) */

/* r2->QB2.toSQL->Js.log */

/* let r3 = */ 
/*   r2 */
/*   ->QB2.leftJoin(Db.GenresTable.t) */
/*   ->QB3.select(((ar, al, g)) => (ar.name, al.name, g.name)) */

/* r3->QB3.toSQL->Js.log */







/* let s1 = QB.from(Db.ArtistsTable.t)->QB1.where(t => Expr.eqV(t.name, "test"))->QB1.select(t => t.id) */
/* let s2 = QB.from(Db.AlbumsTable.t)->QB1.where(t => Expr.eqS(t.id, QB1.asSubQuery(s1))) */

/* s2->QB1.toSQL->Js.log */



// get all artists
QB.from(Db.ArtistsTable.t)->QB1.toSQL->Js.log

// get album names and years of year 1982 or 1992
QB.from(Db.AlbumsTable.t)
  ->QB1.where(a => Expr.or_([Expr.eqV(a.id, 1982), Expr.eqV(a.id, 1992)]))
  ->QB1.select(a => (a.name, a.year))
  ->QB1.toSQL
  ->Js.log

// get all albums with songs (include empty albums)
QB.from(Db.AlbumsTable.t)
  ->QB1.leftJoin(Db.SongsTable.t)
  ->QB2.toSQL
  ->Js.log

// get all album names with song names (exclude empty albums) 
QB.from(Db.AlbumsTable.t)
  ->QB1.innerJoin(Db.SongsTable.t)
  ->QB2.select(((a, s)) => (a.name, s.name))
  ->QB2.toSQL
  ->Js.log


// get all albums which are newer then "Fear of the Dark"
// get avg song duration
// get all songs which are longer then the avg
