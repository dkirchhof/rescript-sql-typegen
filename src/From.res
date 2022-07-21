type t = {
  tableName: string,
  alias: string,
}

let toSQL = from => `FROM ${from.tableName} AS ${from.alias}`
