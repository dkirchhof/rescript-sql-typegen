type t

external make: 'a => t = "%identity"

let toSQL = ref => ref->Obj.magic->Js.Json.stringify
