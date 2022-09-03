type t = array<string>

let make = () => []

let addS = (builder, line) => {
  Js.Array2.push(builder, line)->ignore

  builder
}

let addM = Js.Array2.concat

let build = Js.Array2.joinWith(_, "\n")
