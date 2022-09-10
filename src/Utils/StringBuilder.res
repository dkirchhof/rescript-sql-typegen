type t = array<string>

let make = () => []

let addS = (builder, line) => {
  Js.Array2.push(builder, line)->ignore

  builder
}

let addM = (builder, lines) => {
  lines->Js.Array2.forEach(line => Js.Array2.push(builder, line)->ignore)

  builder
}

let addE = builder => {
  Js.Array2.push(builder, "")->ignore

  builder
}

let build = Js.Array2.joinWith(_, "\n")
let buildWithComma = Js.Array2.joinWith(_, ",\n")
