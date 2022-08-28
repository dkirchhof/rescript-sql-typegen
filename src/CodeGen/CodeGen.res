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
    `${column.name}: Ref.Typed.t<${column.dt->ColumnType.toRescriptType}>,`

  let toOptColumnString = column =>
    `${column.name}: Ref.Typed.t<option<${column.dt->ColumnType.toRescriptType}>>,`

  let toProjectionString = (column, alias) => `"${column.name}": c.${alias}.${column.name}`
}

module Table = {
  type t = {
    moduleName: string,
    tableName: string,
    defaultTableAlias: string,
    columns: array<Column.t>,
  }

  let columnsToObjString = table => {
    let columns =
      table.columns
      ->Js.Array2.map(Column.toProjectionString(_, table.defaultTableAlias))
      ->Js.Array2.joinWith(", ")

    `{"${table.defaultTableAlias}": {${columns}}}`
  }
}

module Join = {
  type t = Inner(Table.t) | Left(Table.t)

  let toSelectable = joinTable =>
    switch joinTable {
    | Inner(table) | Left(table) => `${table.defaultTableAlias}: ${table.moduleName}.columns`
    }

  let toProjectable = joinTable =>
    switch joinTable {
    | Inner(table) => `${table.defaultTableAlias}: ${table.moduleName}.columns`
    | Left(table) => `${table.defaultTableAlias}: ${table.moduleName}.optionalColumns`
    }

  let toJoinMake = joinTable =>
    switch joinTable {
    | Inner(table) => `Join.make("${table.tableName}", "${table.defaultTableAlias}", Inner)`
    | Left(table) => `Join.make("${table.tableName}", "${table.defaultTableAlias}", Left)`
    }

  let columnsToObjString = joinTable =>
    switch joinTable {
    | Inner(table) | Left(table) => Table.columnsToObjString(table)
    }
}

let printTableModule = (table: Table.t) => {
  Js.log(`module ${table.moduleName} = {`)

  Js.log(`  type columns = {`)
  table.columns->Js.Array2.forEach(column => Js.log(`     ${column->Column.toColumnString}`))
  Js.log(`  }`)

  Js.log(``)

  Js.log(`  type optionalColumns = {`)
  table.columns->Js.Array2.forEach(column => Js.log(`     ${column->Column.toOptColumnString}`))
  Js.log(`  }`)

  Js.log(``)

  Js.log(`  type selectables = {${table.defaultTableAlias}: columns}`)
  Js.log(`  type projectables = {${table.defaultTableAlias}: columns}`)

  Js.log(``)

  Js.log(`  let query: Query.t<projectables, selectables, _> =`)
  Js.log(`    Query.makeSelectQuery("${table.tableName}", "${table.defaultTableAlias}")`)
  Js.log(`    ->QB.select(c => ${table->Table.columnsToObjString})`)

  Js.log(`}`)
}

let printJoinModule = (moduleName, table: Table.t, joins: array<Join.t>) => {
  Js.log(`module ${moduleName} = {`)

  Js.log(`  type selectables = {`)
  Js.log(`    ${table.defaultTableAlias}: ${table.moduleName}.columns`)
  joins->Js.Array2.forEach(join => Js.log(`    ${Join.toSelectable(join)},`))
  Js.log(`  }`)

  Js.log(``)

  Js.log(`  type projectables = {`)
  Js.log(`    ${table.defaultTableAlias}: ${table.moduleName}.columns`)
  joins->Js.Array2.forEach(join => Js.log(`    ${Join.toProjectable(join)},`))
  Js.log(`  }`)

  Js.log(``)

  Js.log(`  let createSelectQuery = (): Query.t<projectables, selectables, _> = {`)
  Js.log(`    let from = From.make("${table.tableName}", "${table.defaultTableAlias}")`)

  Js.log(``)

  Js.log(`    let joins = [`)
  joins->Js.Array2.forEach(join => Js.log(`      ${join->Join.toJoinMake},`))
  Js.log(`    ]`)

  Js.log(``)

  Js.log(`    Query.makeJoinQuery(from, joins)->QB.select(c =>`)
  Js.log(`      {`)
  Js.log(`        ${table->Table.columnsToObjString},`)
  joins->Js.Array2.forEach(join => Js.log(`        ${join->Join.columnsToObjString},`))
  Js.log(`      }`)
  Js.log(`    )`)

  Js.log(`  }`)

  Js.log(`}`)
}
