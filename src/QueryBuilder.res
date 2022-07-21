module type Query = {
  type tables
  type projectables
  type selectables

  let query: Query.t<_>
}

let createTableAccessor = () => {
  %raw(`
    new Proxy({}, {
      get(_, alias) {
        return { name: "", alias };
      },
    })
  `)
}

let createColumnAccessor = () => {
  %raw(`
    new Proxy({}, {
      get(_, tableAlias) {
        return new Proxy({}, {
          get(_, name) {
            return { tableAlias, name }
          },
        });
      },
    })
  `)
}

module Make = (Q: Query) => {
  let tableAccessor = createTableAccessor()
  let selectableAccessor = createColumnAccessor()
  let columnAccessor = (createColumnAccessor() :> Q.selectables)

  let select = (query: Query.t<_>, getColumns: Q.projectables => 'a) => {
    let columns = getColumns(selectableAccessor)->Obj.magic

    let columns' = if Js.Array.isArray(columns) {
      columns
    } else {
      [columns]
    }

    ({...query, projections: Some(columns')} :> Query.t<'a>)
  }

  let join = (
    query: Query.t<'projections>,
    getTable: Q.tables => Table.t,
    on: Q.selectables => (Column.t<'a>, Column.t<'a>),
  ) => {
    let table = getTable(tableAccessor)
    let columns = on(columnAccessor)->Obj.magic
    let joins = query.joins->Belt.Array.map(j => {
      if j.table.alias === table.alias {
        {...j, on: Some(columns)}
      } else {
        j
      }
    })

    ({...query, joins} :> Query.t<'projections>)
  }

  let where = (
    query: Query.t<'projections>,
    getSelections: Q.selectables => Selection.Expr.t<_>
  ) => {
    let selections = getSelections(selectableAccessor)->Obj.magic

    ({...query, selection: Some(selections) }:>Query.t<'projections>)
  }
}
