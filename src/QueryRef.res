type t

external make: 'a => t = "%identity"

let toSQL = (ref, queryToString) => `(${queryToString(ref->Obj.magic)})`
