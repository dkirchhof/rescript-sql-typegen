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
  }
  
  let booleanToString = bool => bool ? "true" : "false"
  let optSizeToString = optSize => Belt.Option.mapWithDefault(optSize, "None", s => `Some(${Belt.Int.toString(s)})`)
  let optBoolToString = optNullable => Belt.Option.mapWithDefault(optNullable, "false", booleanToString)
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
    ->addS(`      },`)->build
  }

  let toProjectionString = (column, alias) =>
    `"${column.name}": c.${alias}.${column.name}->QB.unbox`
}

module Columns = {
  let toColumnStrings = columns => columns->Js.Array2.map(Column.toColumnString)
  let toOptColumnStrings = columns => columns->Js.Array2.map(Column.toOptColumnString)
  let toColumnObjs = (columns, tableName) => columns->Js.Array2.map(Column.toColumnObj(_, tableName))
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

let createTableModule = (table: Table.t) => {
  open StringBuilder

  make()
  ->addS(`module ${table.moduleName} = {`)
  ->addS(`  type columns = {`)
  ->addM(Columns.toColumnStrings(table.columns))
  ->addS(`  }`)
  ->addE
  ->addS(`  type optionalColumns = {`)
  ->addM(Columns.toOptColumnStrings(table.columns))
  ->addS(`  }`)
  ->addE
  ->addS(`  let table: DDL.Table.t<columns> = {`)
  ->addS(`    name: "${table.tableName}",`)
  ->addS(`    columns: {`)
  ->addM(Columns.toColumnObjs(table.columns, table.tableName))
  ->addS(`    },`)
  ->addS(`  }`)
  ->addS(`}`)
  ->build
}

let printSelectQueryModule = (moduleName, table: Table.t, alias, joins: array<Source.t>) => {
  open Source

  let from = {table, alias, sourceType: From}
  let sources = Js.Array2.concat([from], joins)

  Js.log(`module ${moduleName} = {`)

  Js.log(`  type selectables = {`)

  sources->Js.Array2.forEach(source => Js.log(`    ${source->Source.toSelectable},`))

  Js.log(`  }`)

  Js.log(``)

  Js.log(`  type projectables = {`)

  sources->Js.Array2.forEach(source => Js.log(`    ${source->Source.toProjectable},`))

  Js.log(`  }`)

  Js.log(``)

  Js.log(`  let createSelectQuery = (): Query.t<projectables, selectables, _> => {`)
  Js.log(`    let from = ${from->Source.toMake}`)

  Js.log(``)

  if Js.Array2.length(joins) > 0 {
    Js.log(`    let joins = [`)

    joins->Js.Array2.forEach(join => Js.log(`      ${join->Source.toMake},`))

    Js.log(`    ]`)
  } else {
    Js.log(`    let joins = []`)
  }

  Js.log(``)

  Js.log(`    Query.makeSelectQuery(from, joins)->QB.select(c =>`)
  Js.log(`      {`)

  sources->Js.Array2.forEach(source => {
    Js.log(`        "${source.alias}": {`)

    source.table.columns->Js.Array2.forEach(column =>
      Js.log(`          ${Column.toProjectionString(column, source.alias)},`)
    )

    Js.log(`        },`)
  })

  Js.log(`      }`)
  Js.log(`    )`)

  Js.log(`  }`)

  Js.log(`}`)
}
