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

  let toProjectionString = (column, alias) => `"${column.name}": c.${alias}.${column.name}->QB.unbox`
}

module Table = {
  type t = {
    moduleName: string,
    tableName: string,
    columns: array<Column.t>,
  }

  let columnsToObjString = (table, alias) => {
    let columns =
      table.columns
      ->Js.Array2.map(Column.toProjectionString(_, alias))
      ->Js.Array2.joinWith(", ")

    `{${columns}}`
  }
}

module Join = {
  type t = Inner(Table.t, string) | Left(Table.t, string)

  let toSelectable = joinTable =>
    switch joinTable {
    | Inner(table, alias) | Left(table, alias) => `${alias}: ${table.moduleName}.columns`
    }

  let toProjectable = joinTable =>
    switch joinTable {
    | Inner(table, alias) => `${alias}: ${table.moduleName}.columns`
    | Left(table, alias) => `${alias}: ${table.moduleName}.optionalColumns`
    }

  let toJoinMake = joinTable =>
    switch joinTable {
    | Inner(table, alias) => `Join.make("${table.tableName}", "${alias}", Inner)`
    | Left(table, alias) => `Join.make("${table.tableName}", "${alias}", Left)`
    }

  let columnsToObjString = joinTable =>
    switch joinTable {
    | Inner(table, alias) | Left(table, alias) => Table.columnsToObjString(table, alias)
    }

  let getAlias = joinTable =>
    switch joinTable {
    | Inner(_, alias) | Left(_, alias) => alias
    }
}

let printTableModule = (table: Table.t) => {
  Js.log(`module ${table.moduleName} = {`)

  Js.log(`  type columns = {`)
  table.columns->Js.Array2.forEach(column => Js.log(`     ${column->Column.toColumnString},`))
  Js.log(`  }`)

  Js.log(``)

  Js.log(`  type optionalColumns = {`)
  table.columns->Js.Array2.forEach(column => Js.log(`     ${column->Column.toOptColumnString},`))
  Js.log(`  }`)

  Js.log(`}`)
}

let printSelectQueryModule = (moduleName, (table: Table.t, alias), joins: array<Join.t>) => {
  Js.log(`module ${moduleName} = {`)

  Js.log(`  type selectables = {`)
  Js.log(`    ${alias}: ${table.moduleName}.columns,`)
  joins->Js.Array2.forEach(join => Js.log(`    ${Join.toSelectable(join)},`))
  Js.log(`  }`)

  Js.log(``)

  Js.log(`  type projectables = {`)
  Js.log(`    ${alias}: ${table.moduleName}.columns,`)
  joins->Js.Array2.forEach(join => Js.log(`    ${Join.toProjectable(join)},`))
  Js.log(`  }`)

  Js.log(``)

  Js.log(`  let createSelectQuery = (): Query.t<projectables, selectables, _> => {`)
  Js.log(`    let from = From.make("${table.tableName}", "${alias}")`)

  Js.log(``)

  Js.log(`    let joins = [`)
  joins->Js.Array2.forEach(join => Js.log(`      ${join->Join.toJoinMake},`))
  Js.log(`    ]`)

  Js.log(``)

  Js.log(`    Query.makeSelectQuery(from, joins)->QB.select(c =>`)
  Js.log(`      {`)
  Js.log(`        "${alias}": ${table->Table.columnsToObjString(alias)},`)
  joins->Js.Array2.forEach(join => Js.log(`        "${join->Join.getAlias}": ${join->Join.columnsToObjString},`))
  Js.log(`      }`)
  Js.log(`    )`)

  Js.log(`  }`)

  Js.log(`}`)
}
