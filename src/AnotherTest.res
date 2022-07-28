let createColumnAccessor = () => {
  %raw(`
    new Proxy({}, {
      get(_, tableAlias) {
        console.log("PROXY", tableAlias);

        return new Proxy({}, {
          get(_, name) {
            return { tableAlias, name }
          },
        });
      },
    })
  `)
}
module type Table = {
  type projectables
  type optionalProjectables
  type selectables
}

module QB3 = {
  type t<'projectables, 'selectables, 'projections>
}

module QB2 = {
  type t<'projectables, 'selectables, 'projections>

  let innerJoin = (
    type p s,
    query: t<('p1, 'p2), ('s1, 's2), 'projections>,
    f: module(Table with type projectables = p and type selectables = s),
  ): QB3.t<('p1, 'p2, p), ('s1, 's2, s), 'projections> => {
    query->Obj.magic
  }

  let select = (
    query: t<'projectables, 'selectables, _>,
    getColumns: 'projectables => 'projections,
  ): t<'projectables, 'selectables, 'projections> => {
    let columnAccessor = createColumnAccessor()
    let columns = getColumns(columnAccessor)

    Js.log(columns)

    query->Obj.magic
  }
}

module QB1 = {
  type t<'projectables, 'selectables, 'projections>

  let innerJoin = (
    type p s,
    query: t<'p1, 's1, 'projections>,
    f: module(Table with type projectables = p and type selectables = s),
  ): QB2.t<('p1, p), ('s1, s), 'projections> => {
    query->Obj.magic
  }

  let leftJoin = (
    type p s,
    query: t<'p1, 's1, 'projections>,
    f: module(Table with type optionalProjectables = p and type selectables = s),
  ): QB2.t<('p1, p), ('s1, s), 'projections> => {
    query->Obj.magic
  }

  let select = (
    query: t<'projectables, 'selectables, _>,
    getColumns: 'projectables => 'projections,
  ): t<'projectables, 'selectables, 'projections> => {
    let columnAccessor = createColumnAccessor()
    let columns = getColumns(columnAccessor)

    Js.log(columns)

    query->Obj.magic
  }
}

module QB = {
  let from = (
    type p s,
    f: module(Table with type projectables = p and type selectables = s),
  ): QB1.t<p, s, p> => {
    /* let module(T) = f */

    let query = ""->Obj.magic

    query
  }
}

let r1 = QB.from(module(Db.ArtistsTable))->QB1.select(t => (t.id, t.name))

let r2 = QB.from(module(Db.ArtistsTable))
->QB1.innerJoin(module(Db.AlbumsTable))
->QB2.select(((ar, al)) => (ar.name, al.name))

let r3 =
  QB.from(module(Db.ArtistsTable))
  ->QB1.leftJoin(module(Db.AlbumsTable))
  ->QB2.innerJoin(module(Db.GenresTable))
