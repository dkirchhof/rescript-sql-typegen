/* let select1: ( */
/*   Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>, */
/*   ('p0, 'p1, 'p2) => Ref.t2<'a>, */
/* ) => Query.executable<'p0, 's0, 'p1, 's1, 'p2, 's2, 'a> */

/* let select2: ( */
/*   Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>, */
/*   ('p0, 'p1, 'p2) => (Ref.t2<'a>, Ref.t2<'b>), */
/* ) => Query.executable<'p0, 's0, 'p1, 's1, 'p2, 's2, ('a, 'b)> */

/* let select3: ( */
/*   Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>, */
/*   ('p0, 'p1, 'p2) => (Ref.t2<'a>, Ref.t2<'b>, Ref.t2<'c>), */
/* ) => Query.executable<'p0, 's0, 'p1, 's1, 'p2, 's2, ('a, 'b, 'c)> */

/* let select3: ( */
/*   Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>, */
/*   ('p0, 'p1, 'p2) => (Ref.t2<'a>, Ref.t2<'b>, Ref.t2<'c>), */
/* ) => Query.executable<'p0, 's0, 'p1, 's1, 'p2, 's2, ('a, 'b, 'c)> */

/* let select4: ( */
/*   Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>, */
/*   ('p0, 'p1, 'p2) => (Ref.t2<'a>, Ref.t2<'b>, Ref.t2<'c>, Ref.t2<'d>), */
/* ) => Query.executable<'p0, 's0, 'p1, 's1, 'p2, 's2, ('a, 'b, 'c, 'd)> */

/* let select5: ( */
/*   Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>, */
/*   ('p0, 'p1, 'p2) => (Ref.t2<'a>, Ref.t2<'b>, Ref.t2<'c>, Ref.t2<'d>, Ref.t2<'e>), */
/* ) => Query.executable<'p0, 's0, 'p1, 's1, 'p2, 's2, ('a, 'b, 'c, 'd, 'e)> */

/* let join1: ( */
/*   Join.joinType, */
/*   Query.t<'p0, 's0, _, _, 'p2, 's2>, */
/*   Schema.table<'p1, 'op1, 's1>, */
/*   string, */
/*   ('s0, 's1, 's2) => Expr.t, */
/* ) => Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2> */

let innerJoin1: (
  Query.t<'p0, 's0, _, _, 'p2, 's2>,
  Schema.table<'p1, 'op1, 's1>,
  string,
  ('s0, 's1, 's2) => Expr.t,
) => Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>

let leftJoin1: (
  Query.t<'p0, 's0, _, _, 'p2, 's2>,
  Schema.table<'p1, 'op1, 's1>,
  string,
  ('s0, 's1, 's2) => Expr.t,
) => Query.t<'p0, 's0, 'op1, 's1, 'p2, 's2>

let innerJoin2: (
  Query.t<'p0, 's0, 'p1, 's1, _, _>,
  Schema.table<'p2, 'op2, 's2>,
  string,
  ('s0, 's1, 's2) => Expr.t,
) => Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2>

let leftJoin2: (
  Query.t<'p0, 's0, 'p1, 's1, _, _>,
  Schema.table<'p2, 'op2, 's2>,
  string,
  ('s0, 's1, 's2) => Expr.t,
) => Query.t<'p0, 's0, 'p1, 's1, 'op2, 's2>
