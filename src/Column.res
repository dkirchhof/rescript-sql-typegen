type t<'t> = {
  tableAlias: string,
  name: string,
}

type u = {
  tableAlias: string,
  name: string,
}

let toSQL = column => `${column.tableAlias}.${column.name}`
