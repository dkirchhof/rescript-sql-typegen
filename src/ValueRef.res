type t

external make: 'a => t = "%identity"

let toSQL = ref => {
  let str = Js.String.make(ref)

  if Js.Types.test(ref, Js.Types.String) {
    `'${str}'`
  } else {
    str
  }
}
