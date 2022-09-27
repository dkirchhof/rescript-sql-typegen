module ColumnType = {
  type t = Integer | String | Varchar

  let toSQLType = dt =>
    switch dt {
    | Integer => `INTEGER`
    | String => `TEXT`
    | Varchar => `VARCHAR`
    }

  let toRescriptType = dt =>
    switch dt {
    | Integer => `int`
    | String => `string`
    | Varchar => `string`
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
    autoIncrement?: bool,
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
    ->addS(`        autoIncrement: ${optBoolToString(column.autoIncrement)},`)
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

  let toColumnObjs = (columns, tableName) =>
    columns->Js.Array2.map(Column.toColumnObj(_, tableName))

  let toDefaultReturnType = columns =>
    columns->Js.Array2.map(column => `      ${Column.toDefaultReturnType(column)},`)

  let toDefaultProjections = columns =>
    columns->Js.Array2.map(column => `        ${Column.toProjectionString(column)},`)

  let toInsertType = (columns: array<Column.t>) =>
    columns
    ->Js.Array2.filter(column => column.skipInInsertQuery->Belt.Option.getWithDefault(false)->not)
    ->Js.Array2.map(column => `      ${Column.toDefaultReturnType(column)},`)

  let toUpdateType = (columns: array<Column.t>) =>
    columns->Js.Array2.map(column => `      ${Column.toOptionalField(column)},`)
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

  let toSelectable = source =>
    source.table.columns->Js.Array2.map(column => {
      let columnName = `${source.alias}_${column.name}`
      let dt = ColumnType.toRescriptType(column.dt)

      `    ${columnName}: DDL.Column.t<${dt}>,`
    })

  let toProjectable = source => {
    source.table.columns->Js.Array2.map(column => {
      let columnName = `${source.alias}_${column.name}`

      let dt = switch source.sourceType {
      | From | InnerJoin => ColumnType.toRescriptType(column.dt)
      | LeftJoin => `option<${ColumnType.toRescriptType(column.dt)}>`
      }

      `    ${columnName}: DDL.Column.t<${dt}>,`
    })
  }

  let toDefaultReturnType = source => {
    source.table.columns->Js.Array2.map(column => {
      let columnName = `${source.alias}_${column.name}`

      let dt = switch source.sourceType {
      | From | InnerJoin => ColumnType.toRescriptType(column.dt)
      | LeftJoin => `option<${ColumnType.toRescriptType(column.dt)}>`
      }

      `      ${columnName}: ${dt},`
    })
  }

  let toDefaultProjections = source => {
    source.table.columns->Js.Array2.map(column => {
      let columnName = `${source.alias}_${column.name}`

      `        ${columnName}: c.${columnName}->DQL.column->DQL.u,`
    })
  }

  let toMake = (source, index) => {
    let name = `${source.table.moduleName}.table.name`
    let joinCondition = `joinCondition${Belt.Int.toString(index)}`

    switch source.sourceType {
    | From => `DQL.From.make(${name}, Some("${source.alias}"))`
    | InnerJoin => `DQL.Join.make(Inner, ${name}, "${source.alias}", ${joinCondition})`
    | LeftJoin => `DQL.Join.make(Left, ${name}, "${source.alias}", ${joinCondition})`
    }
  }
}

module Sources = {
  let toSelectables = sources => sources->Js.Array2.map(Source.toSelectable)->Belt.Array.concatMany

  let toProjectables = sources => sources->Js.Array2.map(Source.toProjectable)->Belt.Array.concatMany

  let toDefaultProjections = sources =>
    sources->Js.Array2.map(Source.toDefaultProjections)->Belt.Array.concatMany

  let toDefaultReturnType = sources =>
    sources->Js.Array2.map(Source.toDefaultReturnType)->Belt.Array.concatMany
}

module Joins = {
  let toJoinConditions = joins => {
    switch joins {
    | [_] => "      let joinCondition0 = getJoinConditions(selectables)"
    | _ => {
        let mapWithIndex = (_, index) => `joinCondition${Belt.Int.toString(index)}`
        let conditions = joins->Js.Array2.mapi(mapWithIndex)

        `      let (${conditions->Js.Array2.joinWith(", ")}) = getJoinConditions(selectables)`
      }
    }
  }

  let toMakeJoins = joins =>
    joins->Js.Array2.mapi((join, i) => `        ${join->Source.toMake(i)},`)
}

let innerJoin = (table, alias): Source.t => {
  table,
  alias,
  sourceType: InnerJoin,
}

let from = (table, alias): Source.t => {
  table,
  alias,
  sourceType: From,
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
  ->addS(`  module Drop = {`)
  ->addS(`    let makeQuery = () => {`)
  ->addS(`      DDL.Drop.Query.make(table)`)
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
  ->addS(`      DQL.Query.make(from, None, table.columns, table.columns)->DQL.select(c => {`)
  ->addM(Columns.toDefaultProjections(table.columns))
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

let makeJoinQueryModule = (moduleName, from, joins: array<Source.t>) => {
  open StringBuilder

  let sources = Js.Array2.concat([from], joins)

  make()
  ->addS(`module ${moduleName} = {`)
  ->addS(`  type projectables = {`)
  ->addM(Sources.toProjectables(sources))
  ->addS(`  }`)
  ->addE
  ->addS(`  type selectables = {`)
  ->addM(Sources.toSelectables(sources))
  ->addS(`  }`)
  ->addE
  ->addS(`  module Select = {`)
  ->addS(`    type t = {`)
  ->addM(Sources.toDefaultReturnType(sources))
  ->addS(`    }`)
  ->addE
  ->addS(`    let makeQuery = getJoinConditions => {`)
  ->addS(`      let from = ${from->Source.toMake(0)}`)
  ->addS(`      let projectables: projectables = ColumnsProxy.make()`)
  ->addS(`      let selectables: selectables = ColumnsProxy.make()`)
  ->addE
  ->addS(Joins.toJoinConditions(joins))
  ->addE
  ->addS(`      let joins = [`)
  ->addM(Joins.toMakeJoins(joins))
  ->addS(`      ]`)
  ->addE
  ->addS(`      DQL.Query.make(from, Some(joins), projectables, selectables)->DQL.select(c => {`)
  ->addM(Sources.toDefaultProjections(sources))
  ->addS(`      })`)
  ->addS(`    }`)
  ->addS(`  }`)
  ->addS(`}`)
  ->build
}
