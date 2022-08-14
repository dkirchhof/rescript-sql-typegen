type t = {aggType: option<Aggregation.t>}

let make = () => {aggType: None}

let toSQL = ref => {
  switch ref.aggType {
  | Some(COUNT) => `COUNT(*)`
  | Some(SUM) => raise(Errors.BAD_QUERY("* is not allowed in SUM aggregations."))
  | Some(AVG) => raise(Errors.BAD_QUERY("* is not allowed in AVG aggregations."))
  | Some(MIN) => raise(Errors.BAD_QUERY("* is not allowed in MIN aggregations."))
  | Some(MAX) => raise(Errors.BAD_QUERY("* is not allowed in MAX aggregations."))
  | None => "*"
  }
}
