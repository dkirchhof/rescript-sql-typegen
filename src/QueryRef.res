type t

external make: SubQuery.t<_> => t = "%identity"

let toSQL = ref => `(${SubQuery.toSQL(ref->Obj.magic)})`
