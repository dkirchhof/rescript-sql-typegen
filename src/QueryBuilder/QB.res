let applyColumnAccessors = fn => fn(Utils.createColumnAccessor())

let column = c => Ref.makeColumnRef(c)
let columnU = c => c->column->Ref.unbox

let value = v => Ref.makeValueRef(v)
let valueU = v => v->value->Ref.unbox

let subQuery = query => Ref.makeQueryRef(query)
let subQueryU = q => q->subQuery->Ref.unbox

let unbox = Ref.unbox

let count = ref => {
  Ref.updateAggType(ref, Some(Aggregation.COUNT))->Obj.magic
}
let countU = ref => ref->count->Ref.unbox

let sumI = ref => {
  Ref.updateAggType(ref, Some(Aggregation.SUM))
}
let sumIU = ref => ref->sumI->Ref.unbox

let sumF = ref => {
  Ref.updateAggType(ref, Some(Aggregation.SUM))
}
let sumFU = ref => ref->sumF->Ref.unbox

let avg = ref => {
  Ref.updateAggType(ref, Some(Aggregation.AVG))
}
let avgU = ref => ref->avg->Ref.unbox

let min = ref => {
  Ref.updateAggType(ref, Some(Aggregation.MIN))
}
let minU = ref => ref->min->Ref.unbox

let max = ref => {
  Ref.updateAggType(ref, Some(Aggregation.MAX))
}
let maxU = ref => ref->max->Ref.unbox

let asc = OrderBy.asc
let desc = OrderBy.desc

let group = GroupBy.group

let join = (query, index, getCondition) => {
  open Query

  let condition = applyColumnAccessors(getCondition)

  let joins = query.joins->Js.Array2.mapi((join, i) => {
    if i === index {
      {...join, condition: Some(condition)}
    } else {
      join
    }
  })

  let query = {
    ...query,
    joins,
  }

  query
}

let where = (query, getSelections) => {
  open Query

  let selections = applyColumnAccessors(getSelections)

  let query = {
    ...query,
    selections: Some(selections),
  }

  query
}

let groupBy = (query, getGroupBys) => {
  open Query

  let groupBys = applyColumnAccessors(getGroupBys)

  let query = {
    ...query,
    groupBys,
  }

  query
}

let having = (query, getHavings) => {
  open Query

  let havings = applyColumnAccessors(getHavings)

  let query = {
    ...query,
    havings: Some(havings),
  }

  query
}

let orderBy = (query, getOrderBys) => {
  open Query

  let orderBys = applyColumnAccessors(getOrderBys)

  let query = {
    ...query,
    orderBys,
  }

  query
}

let select = (query, getProjections) => {
  open Query

  let projections = applyColumnAccessors(getProjections)->Obj.magic

  let query = {
    ...query,
    projections,
  }

  query
}

let rec toSQL = query => {
  open Query

  [
    Projections.toSQL(query.projections, toSQL),
    From.toSQL(query.from),
    Joins.toSQL(query.joins, toSQL),
    Selections.toSQL(query.selections, toSQL),
    GroupBys.toSQL(query.groupBys, toSQL),
    Havings.toSQL(query.havings, toSQL),
    OrderBys.toSQL(query.orderBys, toSQL),
  ]
  ->Js.Array2.filter(s => String.length(s) > 0)
  ->Js.Array2.joinWith(" ")
}

let execute = (query: Query.t<_, _, 'projections>, db) => {
  let queryString = toSQL(query)

  let makeDict = row => {
    let result = Js.Dict.empty()

    let addOrUpdateSubDict = (result, namespace, name, value) => {
      switch result->Js.Dict.get(namespace) {
      | Some(subDict) => subDict->Js.Dict.set(name, value)
      | None => result->Js.Dict.set(namespace, Js.Dict.fromArray([(name, value)]))
      }
    }

    row
    ->Js.Dict.entries
    ->Js.Array2.forEach(((key, value)) => {
      switch key->Js.String2.split(".") {
      | [namespace, name] => addOrUpdateSubDict(result, namespace, name, Js.nullToOption(value))
      | _ => Js.Exn.raiseError("")
      }
    })

    result
  }

  db->SQLite3.prepare(queryString)->SQLite3.all->Js.Array2.map(makeDict)->Obj.magic
}
