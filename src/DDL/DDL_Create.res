module Constraint = {
  type pkOptions = {
    name: string,
    columns: array<string>,
  }

  type foreignColumn = {
    table: string,
    name: string,
  }

  type fkOptions = {
    name: string,
    ownColumn: string,
    foreignColumn: foreignColumn,
  }

  type t = PrimaryKey(pkOptions) | ForeignKey(fkOptions)

  let toSQL = c => {
    switch c {
    | PrimaryKey(pkOptions) =>
      `CONSTRAINT ${pkOptions.name} PRIMARY KEY (${pkOptions.columns->Js.Array2.joinWith(", ")})`
    | ForeignKey(fkOptions) =>
      `CONSTRAINT ${fkOptions.name} FOREIGN KEY (${fkOptions.ownColumn}) REFERENCES ${fkOptions.foreignColumn.table}(${fkOptions.foreignColumn.name})`
    }
  }
}

module Constraints = {
  let toSQL = constraints => {
    constraints->Js.Array2.map(c => `  ${Constraint.toSQL(c)}`)
  }
}

module Column = {
  type t<'t> = {
    table: string,
    name: string,
    dt: string,
    size: option<int>,
    nullable: bool,
    unique: bool,
    default: option<'t>,
  }

  let dtToSQL = (dt, size) => {
    switch size {
    | Some(s) => `${dt}(${s->Js.Int.toString})`
    | None => dt
    }
  }

  let defaultValueToSQL = defaultValue => {
    let str = Js.String.make(defaultValue)

    "DEFAULT " ++ (Js.Types.test(defaultValue, Js.Types.String) ? `'${str}'` : str)
  }

  let toSQL = column =>
    [
      column.name,
      dtToSQL(column.dt, column.size),
      column.nullable ? "" : "NOT NULL",
      column.unique ? "UNIQUE" : "",
      Belt.Option.mapWithDefault(column.default, "", defaultValueToSQL),
    ]
    ->Js.Array2.filter(s => String.length(s) > 0)
    ->Js.Array2.joinWith(" ")
}

module Columns = {
  let toSQL = columns =>
    columns->Obj.magic->Js.Dict.values->Js.Array2.map(column => `  ${column->Column.toSQL}`)
}

module Table = {
  type t<'columns> = {
    name: string,
    columns: 'columns,
    getConstraints: 'columns => array<Constraint.t>,
  }
}

module Query = {
  type t<'columns> = {table: Table.t<'columns>}

  let make = table => {
    table: table,
  }
}

let makePrimaryKey1 = (name, column: Column.t<_>) => {
  open Constraint

  PrimaryKey({name, columns: [column.name]})
}

let makePrimaryKey2 = (name, column1: Column.t<_>, column2: Column.t<_>) => {
  open Constraint

  PrimaryKey({
    name,
    columns: [column1.name, column2.name],
  })
}

let makePrimaryKey3 = (name, column1: Column.t<_>, column2: Column.t<_>, column3: Column.t<_>) => {
  open Constraint

  PrimaryKey({
    name,
    columns: [column1.name, column2.name, column3.name],
  })
}

let makeForeignKey = (name, ownColumn: Column.t<'a>, foreignColumn: Column.t<'a>) => {
  open Constraint

  ForeignKey({
    name,
    ownColumn: ownColumn.name,
    foreignColumn: {table: foreignColumn.table, name: foreignColumn.name},
  })
}

let toSQL = (query: Query.t<_>) => {
  open StringBuilder

  let inner =
    make()
    ->addM(Columns.toSQL(query.table.columns))
    ->addM(query.table.columns->query.table.getConstraints->Constraints.toSQL)
    ->buildWithComma

  make()->addS(`CREATE TABLE ${query.table.name} (`)->addS(inner)->addS(`)`)->build
}

let execute = (query, db) => {
  let sql = toSQL(query)

  db->SQLite3.prepare(sql)->SQLite3.run
}
