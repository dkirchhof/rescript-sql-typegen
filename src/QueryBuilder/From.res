type t = Table.t

let make = Table.make

let toSQL = table => {
  open Table

  `FROM ${table.name} AS "${table.alias}"`
}
