/* let innerJoin = ( */
/* type p s, */
/* query: query<('p1, 'p2), ('s1, 's2), 'projections>, */
/* f: module(Table with type projectables = p and type selectables = s), */
/* ): QB3.query<('p1, 'p2, p), ('s1, 's2, s), 'projections> => { */
/* query->Obj.magic */
/* } */

/* let select = ( */
/* query: query<'projectables, 'selectables, _>, */
/* getColumns: 'projectables => 'projections, */
/* ): query<'projectables, 'selectables, 'projections> => { */
/* let columnAccessor = createColumnAccessorWithJoins() */
/* let columns = getColumns(columnAccessor) */

/* query->Obj.magic */
/* } */
