type t = string;

let toSQL = (projection, queryToString) => {
  /* switch projection { */
  /* | Ref.Untyped.AsteriskRef(ref) => `${AsteriskRef.toSQL(ref)} AS ${projection.alias}` */
  /* | Ref.Untyped.ColumnRef(ref) => `${ColumnRef.toSQL(ref)} AS ${projection.alias}` */
  /* | Ref.Untyped.ValueRef(ref) => `${ValueRef.toSQL(ref)} AS ${projection.alias}` */
  /* | Ref.Untyped.QueryRef(ref) => `${QueryRef.toSQL(ref, queryToString)} AS ${projection.alias}` */
  /* } */
  "COLUMN"
}
