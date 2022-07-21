open CodeGen

let artists = {
  name: "artists",
  columns: [Int("id"), Text("name")],
}

let songs = {
  name: "songs",
  columns: [Int("id"), Int("artist"), Text("title")],
}

makeTableModule(artists)->Js.log
makeTableModule(songs)->Js.log

/* makeQueryModule(From(artists, "a"), [LeftJoin(songs, "s")])->Js.log */
