let sanitize = Js.String2.replaceByRe(_, %re("/'/g"), "''")

let valueToSQL = value => {
  let str = Js.String.make(value)

  if Js.Types.test(value, Js.Types.String) {
    `'${sanitize(str)}'`
  } else {
    str
  }
}
