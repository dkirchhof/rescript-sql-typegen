type t<'p0, 's0> = Table.t<'p0, 's0>

let toSQL = table => {
  open Table

  `FROM ${table.name} AS ${table.alias}`
}
