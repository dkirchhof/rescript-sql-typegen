type t = {
  name: string,
  alias: string,
}

let make = (tableName, tableAlias) => {name: tableName, alias: tableAlias}
