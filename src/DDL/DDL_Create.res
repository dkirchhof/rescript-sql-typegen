module Constraint = {
  type pkOptions = {
    name: string,
    columns: array<string>,
  }

  type foreignColumn = {
    table: string,
    name: string,
  }

  type referenceOption = RESTRICT | CASCADE | SET_NULL | NO_ACTION | SET_DEFAULT

  let referenceOptionToSQL = referenceOption =>
    switch referenceOption {
    | RESTRICT => "RESTRICT"
    | CASCADE => "CASCADE"
    | SET_NULL => "SET NULL"
    | NO_ACTION => "NO ACTION"
    | SET_DEFAULT => "SET DEFAULT"
    }

  type fkOptions = {
    name: string,
    ownColumn: string,
    foreignColumn: foreignColumn,
    onUpdate: referenceOption,
    onDelete: referenceOption,
  }

  type t = PrimaryKey(pkOptions) | ForeignKey(fkOptions)

  let toSQL = c => {
    switch c {
    | PrimaryKey(pkOptions) =>
      `CONSTRAINT ${pkOptions.name} PRIMARY KEY (${pkOptions.columns->Js.Array2.joinWith(", ")})`
    | ForeignKey(fkOptions) => {
        open StringBuilder

        make()
        ->addS(`CONSTRAINT ${fkOptions.name}`)
        ->addS(`FOREIGN KEY (${fkOptions.ownColumn})`)
        ->addS(`REFERENCES ${fkOptions.foreignColumn.table}(${fkOptions.foreignColumn.name})`)
        ->addS(`ON UPDATE ${fkOptions.onUpdate->referenceOptionToSQL}`)
        ->addS(`ON DELETE ${fkOptions.onDelete->referenceOptionToSQL}`)
        ->buildWithSpace
      }
    }
  }
}

module Constraints = {
  let toSQL = constraints => {
    constraints->Js.Array2.map(c => `  ${Constraint.toSQL(c)}`)
  }
}

module Column = {
  open DDL_Column

  let dtToSQL = (dt, size) => {
    switch size {
    | Some(s) => `${dt}(${s->Js.Int.toString})`
    | None => dt
    }
  }

  let defaultValueToSQL = defaultValue => {
    `DEFAULT ${Sanitizer.valueToSQL(defaultValue)}`
  }

  let toSQL = column =>
    [
      column.name,
      dtToSQL(column.dt, column.size),
      column.nullable ? "" : "NOT NULL",
      column.unique ? "UNIQUE" : "",
      column.autoIncrement ? "AUTO_INCREMENT" : "",
      Belt.Option.mapWithDefault(column.default, "", defaultValueToSQL),
    ]
    ->Js.Array2.filter(s => String.length(s) > 0)
    ->Js.Array2.joinWith(" ")
}

module Columns = {
  let toSQL = columns =>
    columns->Obj.magic->Js.Dict.values->Js.Array2.map(column => `  ${column->Column.toSQL}`)
}

module Query = {
  type t<'columns> = {table: DDL_Table.t<'columns>, constraints: array<Constraint.t>}

  let make = table => {
    table,
    constraints: [],
  }
}

let _addPrimaryKey = (query: Query.t<_>, name, columnNames) => {
  let constraints = Js.Array2.concat(query.constraints, [PrimaryKey({name, columns: columnNames})])

  {...query, constraints}
}

let addPrimaryKey1 = (query: Query.t<'columns>, name, getColumn: 'columns => DDL_Column.t<_>) => {
  let column = getColumn(query.table.columns)

  _addPrimaryKey(query, name, [column.name])
}

let addPrimaryKey2 = (
  query: Query.t<'columns>,
  name,
  getColumn: 'columns => (DDL_Column.t<_>, DDL_Column.t<_>),
) => {
  let (column1, column2) = getColumn(query.table.columns)

  _addPrimaryKey(query, name, [column1.name, column2.name])
}

let addPrimaryKey3 = (
  query: Query.t<'columns>,
  name,
  getColumn: 'columns => (DDL_Column.t<_>, DDL_Column.t<_>, DDL_Column.t<_>),
) => {
  let (column1, column2, column3) = getColumn(query.table.columns)

  _addPrimaryKey(query, name, [column1.name, column2.name, column3.name])
}

let addForeignKey = (
  query: Query.t<'columns>,
  name,
  getOwnColumn: 'columns => DDL_Column.t<'a>,
  foreignColumn: DDL_Column.t<'a>,
  onUpdate,
  onDelete,
) => {
  open Constraint

  let ownColumn = getOwnColumn(query.table.columns).name
  let foreignColumn = {table: foreignColumn.table, name: foreignColumn.name}

  let constraints = Js.Array2.concat(
    query.constraints,
    [ForeignKey({name, ownColumn, foreignColumn, onUpdate, onDelete})],
  )

  {...query, constraints}
}

let toSQL = (query: Query.t<_>) => {
  open StringBuilder

  let inner =
    make()
    ->addM(Columns.toSQL(query.table.columns))
    ->addM(Constraints.toSQL(query.constraints))
    ->buildWithComma

  make()->addS(`CREATE TABLE ${query.table.name} (`)->addS(inner)->addS(`)`)->build
}

let execute = (query, mutate: Provider.mutate<_>, connection) => {
  toSQL(query)->mutate(connection)
}
