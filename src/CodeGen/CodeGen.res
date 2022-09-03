module ColumnType = {
  type t = Integer | String

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
  }

  let toColumnString = column =>
    `${column.name}: Ref.Typed.t<${column.dt->ColumnType.toRescriptType}>`

  let toOptColumnString = column =>
    `${column.name}: Ref.Typed.t<option<${column.dt->ColumnType.toRescriptType}>>`

  let toProjectionString = (column, alias) =>
    `"${column.name}": c.${alias}.${column.name}->QB.unbox`
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
  ->addM(table.columns->Js.Array2.map(column => `     ${column->Column.toColumnString},`))
  ->addS(`  }`)
  ->addS(``)
  ->addS(`  type optionalColumns = {`)
  ->addM(table.columns->Js.Array2.map(column => `     ${column->Column.toOptColumnString},`))
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
