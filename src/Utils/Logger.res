let log = (title, string) => {
  Js.log2(`\x1b[1m%s\x1b[0m`, title)
  Js.log(string)
  Js.log("")
}
