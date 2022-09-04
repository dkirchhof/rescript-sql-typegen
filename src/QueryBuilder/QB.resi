let column: DDL.Column.t<'a> => Ref.t<'a>
let columnU: DDL.Column.t<'a> => 'a
let value: 'a => Ref.t<'a>
let valueU: 'a => 'a
let subQuery: Query.t<_, _, _> => Ref.t<'projections>
let subQueryU: Query.t<_, _, _> => 'projections

let unbox: Ref.t<'a> => 'a

let count: Ref.t<'a> => Ref.t<int>
let countU: Ref.t<'a> => int
let sumI: Ref.t<int> => Ref.t<int>
let sumIU: Ref.t<int> => int
let sumF: Ref.t<float> => Ref.t<float>
let sumFU: Ref.t<float> => float
let avg: Ref.t<'a> => Ref.t<'a>
let avgU: Ref.t<'a> => 'a
let min: Ref.t<'a> => Ref.t<'a>
let minU: Ref.t<'a> => 'a
let max: Ref.t<'a> => Ref.t<'a>
let maxU: Ref.t<'a> => 'a

let asc: Ref.t<'a> => OrderBy.t
let desc: Ref.t<'a> => OrderBy.t

let group: Ref.t<'a> => GroupBy.t

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
