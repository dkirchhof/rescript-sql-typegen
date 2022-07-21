module Column = {
  type t =
    | Int(string)
    | OptionalInt(string)

    | Real(string)
    | OptionalReal(string)

    | Text(string)
    | OptionalText(string)

    | Blob(string)
    | OptionalBlob(string)

  let toTypeString = column =>
    switch column {
    | Int(name) => `${name}: int`
    | OptionalInt(name) => `${name}: option<int>`
    | Real(name) => `${name}: float`
    | OptionalReal(name) => `${name}: option<float>`
    | Text(name) => `${name}: string`
    | OptionalText(name) => `${name}: option<string>`
    | Blob(name) => `${name}: string`
    | OptionalBlob(name) => `${name}: option<string>`
    }

  let toOptionalTypeString = column =>
    switch column {
    | Int(name) => `${name}: option<int>`
    | OptionalInt(name) => `${name}: option<int>`
    | Real(name) => `${name}: option<float>`
    | OptionalReal(name) => `${name}: option<float>`
    | Text(name) => `${name}: option<string>`
    | OptionalText(name) => `${name}: option<string>`
    | Blob(name) => `${name}: option<string>`
    | OptionalBlob(name) => `${name}: option<string>`
    }
}

type table = {
  name: string,
  columns: array<Column.t>,
}

type from = From(table, string)
type join = InnerJoin(table, string) | LeftJoin(table, string)

let indent = (str, indentation) => Js.String2.repeat(" ", indentation) ++ str

let wrapInType = (rows, typeName) =>
  Belt.Array.concatMany([[`type ${typeName} = {`], rows->Js.Array2.map(indent(_, 2)), [`}`]])

let wrapInModule = (rows, moduleName) =>
  Belt.Array.concatMany([[`module ${moduleName} = {`], rows->Js.Array2.map(indent(_, 2)), [`}`]])

let makeModuleName = tableName => {
  let firstUpper = tableName->Js.String2.get(0)->Js.String2.toUpperCase
  let rest = tableName->Js.String2.substringToEnd(~from=1)

  `${firstUpper}${rest}Table`
}

let makeTableModule = table => {
  let moduleName = makeModuleName(table.name)

  let normalColumnsType =
    table.columns->Js.Array2.map(c => Column.toTypeString(c) ++ ",")->wrapInType("columns")

  let optionalColumnsType =
    table.columns
    ->Js.Array2.map(c => Column.toOptionalTypeString(c) ++ ",")
    ->wrapInType("optionalColumns")

  Belt.Array.concatMany([normalColumnsType, [""], optionalColumnsType])
  ->wrapInModule(moduleName)
  ->Js.Array2.joinWith("\n")
}

/* let makeQueryModule = (from, joins) => { */
/* "" */
/* } */
