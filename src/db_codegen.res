open CodeGen

let albums = {
  name: "albums",
  columns: [Int("id"), Text("name"), Int("artistId"), Int("genreId")],
}

let genres = {
  name: "genres",
  columns: [Int("id"), Text("name")],
}

let artists = {
  name: "artists",
  columns: [Int("id"), Text("name")],
}

makeTableModule(albums)->Js.log
Js.log("")

makeTableModule(genres)->Js.log
Js.log("")

makeTableModule(artists)->Js.log
Js.log("")

/* makeQueryModule(From(artists, "a"), [LeftJoin(, "s")])->Js.log */

makeQueryModule("ArtistsQuery", From(artists, "a"), [LeftJoin(artists, "art")])->Js.log
