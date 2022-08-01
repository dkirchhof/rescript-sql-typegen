let r1 =
  QB.from(Db.ArtistsTable.t)
  ->QB1.where(t =>
    Expr.and_([
      Expr.eqV(t.id, 1), 
      Expr.or_([
        Expr.eqC(t.name, t.name), Expr.eqV(t.name, "test")
      ])
    ])
  )
  ->QB1.select(t => (t.id, t.name))

r1->QB1.toSQL->Js.log

let r2 =
  r1
  ->QB1.innerJoin(Db.AlbumsTable.t)
  ->QB2.where(((ar, al)) => Expr.eqC(ar.id, al.id))
  ->QB2.select(((ar, al)) => (ar.name, al.name))

r2->QB2.toSQL->Js.log

let r3 = 
  r2
  ->QB2.leftJoin(Db.GenresTable.t)
  ->QB3.select(((ar, al, g)) => (ar.name, al.name, g.name))

r3->QB3.toSQL->Js.log
