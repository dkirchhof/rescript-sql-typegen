/* let select1: ( */
/* Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>, */
/* ('p0, 'p1, 'p2) => Ref.t2<'a>, */
/* ) => Query.executable<'p0, 's0, 'p1, 's1, 'p2, 's2, 'a> */

/* let select2: ( */
/* Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>, */
/* ('p0, 'p1, 'p2) => (Ref.t2<'a>, Ref.t2<'b>), */
/* ) => Query.executable<'p0, 's0, 'p1, 's1, 'p2, 's2, ('a, 'b)> */

/* let select3: ( */
/* Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>, */
/* ('p0, 'p1, 'p2) => (Ref.t2<'a>, Ref.t2<'b>, Ref.t2<'c>), */
/* ) => Query.executable<'p0, 's0, 'p1, 's1, 'p2, 's2, ('a, 'b, 'c)> */

/* let select3: ( */
/* Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>, */
/* ('p0, 'p1, 'p2) => (Ref.t2<'a>, Ref.t2<'b>, Ref.t2<'c>), */
/* ) => Query.executable<'p0, 's0, 'p1, 's1, 'p2, 's2, ('a, 'b, 'c)> */

/* let select4: ( */
/* Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>, */
/* ('p0, 'p1, 'p2) => (Ref.t2<'a>, Ref.t2<'b>, Ref.t2<'c>, Ref.t2<'d>), */
/* ) => Query.executable<'p0, 's0, 'p1, 's1, 'p2, 's2, ('a, 'b, 'c, 'd)> */

/* let select5: ( */
/* Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>, */
/* ('p0, 'p1, 'p2) => (Ref.t2<'a>, Ref.t2<'b>, Ref.t2<'c>, Ref.t2<'d>, Ref.t2<'e>), */
/* ) => Query.executable<'p0, 's0, 'p1, 's1, 'p2, 's2, ('a, 'b, 'c, 'd, 'e)> */

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

let select: (
  Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>,
  ('p0, 'p1, 'p2) => 'projections,
) => Query.executable<'p0, 's0, 'p1, 's1, 'p2, 's2, 'projections>
