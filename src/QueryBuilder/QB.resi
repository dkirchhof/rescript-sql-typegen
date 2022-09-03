let column: DDL.Column.t<'a> => Ref.Typed.t<'a>
let value: 'a => Ref.Typed.t<'a>
let subQuery: Query.t<_, _, _> => Ref.Typed.t<'projections>

let unbox: Ref.Typed.t<'a> => 'a

let count: Ref.Typed.t<'a> => Ref.Typed.t<int>
let sumI: Ref.Typed.t<int> => Ref.Typed.t<int>
let sumF: Ref.Typed.t<float> => Ref.Typed.t<float>
let avg: Ref.Typed.t<'a> => Ref.Typed.t<'a>
let min: Ref.Typed.t<'a> => Ref.Typed.t<'a>
let max: Ref.Typed.t<'a> => Ref.Typed.t<'a>

let asc: Ref.Typed.t<'a> => OrderBy.t
let desc: Ref.Typed.t<'a> => OrderBy.t

let join: (
  Query.t<'projectables, 'selectables, 'projections>,
  int,
  'selectables => Expr.t,
) => Query.t<'projectables, 'selectables, 'projections>

let where: (Query.t<'projectables, 'selectables, 'projections>, 'selectables => Expr.t) => Query.t<'projectables, 'selectables, 'projections>

let groupBy: (
  Query.t<'projectables, 'selectables, 'projections>,
  'selectables => GroupBys.t,
) => Query.t<'projectables, 'selectables, 'projections>

let having: (Query.t<'projectables, 'selectables, 'projections>, 'selectables => Expr.t) => Query.t<'projectables, 'selectables, 'projections>

let orderBy: (
  Query.t<'projectables, 'selectables, 'projections>,
  'selectables => OrderBys.t,
) => Query.t<'projectables, 'selectables, 'projections>

let select: (
  Query.t<'projectables, 'selectables, _>,
  'projectables => (Js.t<Js.t<{..}>> as 'projections),
) => Query.t<'projectables, 'selectables, 'projections>

let toSQL: Query.t<_, _, _> => string

let execute: (Query.t<_, _, 'projections>, SQLite3.db) => QueryResult.t<'projections>
