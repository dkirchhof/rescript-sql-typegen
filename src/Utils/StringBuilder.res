type t = array<string>

let make = () => []

let addS = (builder, line) => {
  Js.Array2.push(builder, line)->ignore

  builder
}

let addSO = (builder, optionalLine) => {
  switch optionalLine {
  | Some(line) => addS(builder, line)->ignore
  | None => ignore()
  }

  builder
}

let addM = (builder, lines) => {
  lines->Js.Array2.forEach(line => Js.Array2.push(builder, line)->ignore)

  builder
}

let addMO = (builder, optionalLines) => {
  switch optionalLines {
  | Some(lines) => addM(builder, lines)->ignore
  | None => ignore()
  }

  builder
}

let addE = builder => {
  Js.Array2.push(builder, "")->ignore

  builder
}

let build = Js.Array2.joinWith(_, "\n")
let buildWithComma = Js.Array2.joinWith(_, ",\n")
