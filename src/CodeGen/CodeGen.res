module ColumnType = {
  type t = Integer | String

  let toSQLType = dt =>
    switch dt {
    | Integer => `INTEGER`
    | String => `TEXT`
    }

  let toRescriptType = dt =>
    switch dt {
    | Integer => `int`
    | String => `string`
    }
}

module Column = {
  type t = {
    name: string,
    dt: ColumnType.t,
    size?: int,
    nullable?: bool,
    unique?: bool,
    default?: string,
    skipInInsertQuery?: bool,
  }

  let booleanToString = bool => bool ? "true" : "false"

  let optSizeToString = optSize =>
    Belt.Option.mapWithDefault(optSize, "None", s => `Some(${Belt.Int.toString(s)})`)

  let optBoolToString = optNullable =>
    Belt.Option.mapWithDefault(optNullable, "false", booleanToString)

  let optDefaultToString = optDefault => Belt.Option.getWithDefault(optDefault, "None")

  let toColumnString = column =>
    `    ${column.name}: DDL.Column.t<${column.dt->ColumnType.toRescriptType}>,`

  let toOptColumnString = column =>
    `    ${column.name}: DDL.Column.t<option<${column.dt->ColumnType.toRescriptType}>>,`

  let toColumnObj = (column, tableName) => {
    open StringBuilder

    make()
    ->addS(`      ${column.name}: {`)
    ->addS(`        table: "${tableName}",`)
    ->addS(`        name: "${column.name}",`)
    ->addS(`        dt: "${ColumnType.toSQLType(column.dt)}",`)
    ->addS(`        size: ${optSizeToString(column.size)},`)
    ->addS(`        nullable: ${optBoolToString(column.nullable)},`)
    ->addS(`        unique: ${optBoolToString(column.unique)},`)
    ->addS(`        default: ${optDefaultToString(column.default)},`)
    ->addS(`      },`)
    ->build
  }

  let toProjectionString = column => `${column.name}: c.${column.name}->DQL.column->DQL.u`

  let toDefaultReturnType = column => `${column.name}: ${ColumnType.toRescriptType(column.dt)}`

  let toOptionalField = column => `${column.name}?: ${ColumnType.toRescriptType(column.dt)}`
}

module Columns = {
  let toColumnStrings = columns => columns->Js.Array2.map(Column.toColumnString)

  let toOptColumnStrings = columns => columns->Js.Array2.map(Column.toOptColumnString)

  let toColumnObjs = (columns, tableName) =>
    columns->Js.Array2.map(Column.toColumnObj(_, tableName))

  /* let toProjections = (sourceAlias, columns) => */
  /* columns->Js.Array2.map(column => `          ${Column.toProjectionString(column, sourceAlias)},`) */

  let toDefaultReturnType = columns =>
    columns->Js.Array2.map(column => `      ${Column.toDefaultReturnType(column)},`)

  let toInsertType = (columns: array<Column.t>) =>
    columns
    ->Js.Array2.filter(column => column.skipInInsertQuery->Belt.Option.getWithDefault(false)->not)
    ->Js.Array2.map(column => `      ${Column.toDefaultReturnType(column)},`)

  let toUpdateType = (columns: array<Column.t>) =>
    columns
    ->Js.Array2.map(column => `      ${Column.toOptionalField(column)},`)
}

module Table = {
  type t = {
    moduleName: string,
    tableName: string,
    columns: array<Column.t>,
  }
}

module Source = {
  type sourceType = From | InnerJoin | LeftJoin

  type t = {
    sourceType: sourceType,
    table: Table.t,
    alias: string,
  }

  let toSelectable = source => `${source.alias}: ${source.table.moduleName}.columns`

  let toProjectable = source =>
    switch source.sourceType {
    | From | InnerJoin => `${source.alias}: ${source.table.moduleName}.columns`
    | LeftJoin => `${source.alias}: ${source.table.moduleName}.optionalColumns`
    }

  let toMake = source =>
    switch source.sourceType {
    | From => `From.make("${source.table.tableName}", "${source.alias}")`
    | InnerJoin => `Join.make("${source.table.tableName}", "${source.alias}", Inner)`
    | LeftJoin => `Join.make("${source.table.tableName}", "${source.alias}", Left)`
    }

  let toProjections = source => {
    open StringBuilder

    make()
    ->addS(`        "${source.alias}": {`)
    /* ->addM(Columns.toProjections(source.alias, source.table.columns)) */
    ->addS(`        },`)
    ->build
  }
}

module Sources = {
  let toSelectables = sources =>
    sources->Js.Array2.map(source => `    ${source->Source.toSelectable},`)

  let toProjectables = sources =>
    sources->Js.Array2.map(source => `    ${source->Source.toProjectable},`)

  let toJoins = joins => joins->Js.Array2.map(join => `      ${join->Source.toMake},`)

  /* let toDefaultProjections = sources => sources->Js.Array2.map(Source.toProjections) */

  let toDefaultProjections = columns =>
    columns->Js.Array2.map(column => `        ${Column.toProjectionString(column)},`)
}

let innerJoin = (table, alias): Source.t => {
  table,
  alias,
  sourceType: InnerJoin,
}

let leftJoin = (table, alias): Source.t => {
  table,
  alias,
  sourceType: LeftJoin,
}

let makeTableModule = (table: Table.t) => {
  open StringBuilder

  make()
  ->addS(`module ${table.moduleName} = {`)
  ->addS(`  type columns = {`)
  ->addM(Columns.toColumnStrings(table.columns))
  ->addS(`  }`)
  ->addE
  ->addS(`  let table: DDL.Table.t<columns> = {`)
  ->addS(`    name: "${table.tableName}",`)
  ->addS(`    columns: {`)
  ->addM(Columns.toColumnObjs(table.columns, table.tableName))
  ->addS(`    },`)
  ->addS(`  }`)
  ->addE
  ->addS(`  module Create = {`)
  ->addS(`    let makeQuery = () => {`)
  ->addS(`      DDL.Create.Query.make(table)`)
  ->addS(`    }`)
  ->addS(`  }`)
  ->addE
  ->addS(`  module Select = {`)
  ->addS(`    type t = {`)
  ->addM(Columns.toDefaultReturnType(table.columns))
  ->addS(`    }`)
  ->addE
  ->addS(`    let makeQuery = () => {`)
  ->addS(`      let from = DQL.From.make(table.name, None)`)
  ->addE
  ->addS(`      DQL.Query.make(from, None, table.columns)->DQL.select(c => {`)
  ->addM(Sources.toDefaultProjections(table.columns))
  ->addS(`      })`)
  ->addS(`    }`)
  ->addS(`  }`)
  ->addE
  ->addS(`  module Insert = {`)
  ->addS(`    type t = {`)
  ->addM(Columns.toInsertType(table.columns))
  ->addS(`    }`)
  ->addE
  ->addS(`    let makeQuery = (): DML.Insert.Query.t<t> => {`)
  ->addS(`      DML.Insert.Query.make(table.name)`)
  ->addS(`    }`)
  ->addS(`  }`)
  ->addE
  ->addS(`  module Update = {`)
  ->addS(`    type t = {`)
  ->addM(Columns.toUpdateType(table.columns))
  ->addS(`    }`)
  ->addE
  ->addS(`    let makeQuery = (): DML.Update.Query.t<t, columns> => {`)
  ->addS(`      DML.Update.Query.make(table.name, table.columns)`)
  ->addS(`    }`)
  ->addS(`  }`)
  ->addE
  ->addS(`  module Delete = {`)
  ->addS(`    let makeQuery = () => {`)
  ->addS(`      DML.Delete.Query.make(table.name, table.columns)`)
  ->addS(`    }`)
  ->addS(`  }`)
  ->addS(`}`)
  ->build
}

let makeSelectQueryModule = (moduleName, table: Table.t, alias, joins: array<Source.t>) => {
  open Source

  let from = {table, alias, sourceType: From}
  let sources = Js.Array2.concat([from], joins)

  open StringBuilder

  make()
  ->addS(`module ${moduleName} = {`)
  ->addS(`  type selectables = {`)
  ->addM(Sources.toSelectables(sources))
  ->addS(`  }`)
  ->addE
  ->addS(`  type projectables = {`)
  ->addM(Sources.toProjectables(sources))
  ->addS(`  }`)
  ->addE
  ->addS(`  let makeSelectQuery = (): Query.t<projectables, selectables, _> => {`)
  ->addS(`    let from = ${from->Source.toMake}`)
  ->addE
  ->addS(`    let joins = [`)
  ->addM(Sources.toJoins(joins))
  ->addS(`    ]`)
  ->addE
  ->addS(`    Query.makeSelectQuery(from, joins)->QB.select(c =>`)
  ->addS(`      {`)
  /* ->addM(Sources.toDefaultProjections(sources)) */
  ->addS(`      }`)
  ->addS(`    )`)
  ->addS(`  }`)
  ->addS(`}`)
  ->build
}
