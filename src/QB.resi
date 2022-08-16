let all: unit => 'a
let value: 'a => Ref.Typed.t<'a>
/* let subQuery: Query.executable<_, _, _, _, _, _, Ref.Typed.t<'projections>> => Ref.Typed.t<'projections> */

let count: Ref.Typed.t<'a> => Ref.Typed.t<int>
let countAll: unit => Ref.Typed.t<int>
let sumI: Ref.Typed.t<int> => Ref.Typed.t<int>
let sumF: Ref.Typed.t<float> => Ref.Typed.t<float>
let avg: Ref.Typed.t<'a> => Ref.Typed.t<'a>
let min: Ref.Typed.t<'a> => Ref.Typed.t<'a>
let max: Ref.Typed.t<'a> => Ref.Typed.t<'a>

let join: (
  Query.t<'projectables, 'selectables>,
  int,
  'selectables => Expr.t,
) => Query.t<'projectables, 'selectables>

let where: (
  Query.t<'projectables, 'selectables>,
  'selectables => Expr.t,
) => Query.t<'projectables, 'selectables>

let groupBy: (
  Query.t<'projectables, 'selectables>,
  'selectables => GroupBys.t,
) => Query.t<'projectables, 'selectables>

let having: (
  Query.t<'projectables, 'selectables>,
  'selectables => Expr.t,
) => Query.t<'projectables, 'selectables>

let orderBy: (
  Query.t<'projectables, 'selectables>,
  'selectables => OrderBys.t,
) => Query.t<'projectables, 'selectables>

let select: (
  Query.t<'projectables, 'selectables>,
  'projectables => 'projections,
) => Query.executable<'projectables, 'selectables, 'projections>

let toSQL: Query.executable<_, _, _> => string
