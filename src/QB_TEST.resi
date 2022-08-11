let v: 'a => Ref.t2<'a>
let s: Query.executable<_, _, _, _, _, _, Ref.t2<'projections>> => Ref.t2<'projections>

let count: Ref.t2<'a> => Ref.t2<'a>
let sum: Ref.t2<'a> => Ref.t2<'a>
let avg: Ref.t2<'a> => Ref.t2<'a>
let min: Ref.t2<'a> => Ref.t2<'a>
let max: Ref.t2<'a> => Ref.t2<'a>

let from: (Schema.table<'c, 'oc>, string) => Query.t<'c, 'c, _, _, _, _>

let innerJoin1: (
  Query.t<'p0, 's0, _, _, 'p2, 's2>,
  Schema.table<'c, 'oc>,
  string,
  ('s0, 'c, 's2) => Expr.t,
) => Query.t<'p0, 's0, 'c, 'c, 'p2, 's2>

let leftJoin1: (
  Query.t<'p0, 's0, _, _, 'p2, 's2>,
  Schema.table<'c, 'oc>,
  string,
  ('s0, 'c, 's2) => Expr.t,
) => Query.t<'p0, 's0, 'oc, 'c, 'p2, 's2>

let innerJoin2: (
  Query.t<'p0, 's0, 'p1, 's1, _, _>,
  Schema.table<'c, 'oc>,
  string,
  ('s0, 's1, 'c) => Expr.t,
) => Query.t<'p0, 's0, 'p1, 's1, 'c, 'c>

let leftJoin2: (
  Query.t<'p0, 's0, 'p1, 's1, _, _>,
  Schema.table<'c, 'oc>,
  string,
  ('s0, 's1, 'c) => Expr.t,
) => Query.t<'p0, 's0, 'p1, 's1, 'oc, 'c>

let where: (
  Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>,
  ('s0, 's1, 's2) => Expr.t,
) => Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>

let groupBy: (
  Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>,
  ('s0, 's1, 's2) => GroupBys.t,
) => Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>

let having: (
  Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>,
  ('s0, 's1, 's2) => Expr.t,
) => Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>

let orderBy: (
  Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>,
  ('s0, 's1, 's2) => OrderBys.t,
) => Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>

let select: (
  Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>,
  ('p0, 'p1, 'p2) => 'projections,
) => Query.executable<'p0, 's0, 'p1, 's1, 'p2, 's2, 'projections>
