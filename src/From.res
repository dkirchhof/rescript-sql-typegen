type t = Table.t

let toSQL = table => {
  open Table

  `FROM ${table.name} AS ${table.alias}`
}
