let r1 =
  QB.from(module(Db.ArtistsTable))
  ->QB1.select(t => (t.id, t.name))
  ->QB1.where(t =>
    Expr.and_([Expr.eqV(t.id, 1), Expr.or_([Expr.eqC(t.name, t.name), Expr.eqV(t.name, "test")])])
  )

r1->QB1.toSQL->Utils.inspect
 

/* let r2 = QB.from(module(Db.ArtistsTable))->QB1.innerJoin(module(Db.AlbumsTable)) */
/* ->QB2.select(((ar, al)) => (ar.name, al.name)) */

/* Util.inspect(r2) */

/* let r3 = */
/* QB.from(module(Db.ArtistsTable)) */
/* ->QB1.leftJoin(module(Db.AlbumsTable)) */
/* ->QB2.innerJoin(module(Db.GenresTable)) */

/* Util.inspect(r3) */
