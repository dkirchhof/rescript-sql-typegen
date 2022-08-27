open QB

let log = (title, query) => {
  Js.log2(`\x1b[1m%s\x1b[0m`, title)
  Js.log(query->toSQL ++ ";")
  Js.log("")
}

let logAndExecute = (title, query, db) => {
  Js.log2(`\x1b[1m%s\x1b[0m`, title)
  Js.log(query->toSQL ++ ";")

  let result = execute(query, db)

  Js.log(result)
  Js.log("")
}

%%raw(`
  import { inspect as inspect_ } from "util";
`)

let inspect = %raw(`
  function(value) {
    console.log(inspect_(value, false, 10, true));
  }
`)

let db = SQLite3.createDB("db.db")

log("get all artists:", Db.ArtistsTable.query)

log(
  "get all artist names in alphabetic order:",
  Db.ArtistsTable.query
  ->orderBy(c => [OrderBy.asc(c.artist.name)])
  ->select(c => {"artist": {"name": c.artist.name->unbox}}),
)

log(
  "get number of songs:",
  Db.SongsTable.query->select(c => {"song": {"count": c.song.id->count->unbox}}),
)

log(
  "get albums of year 1982 or 1992 (OR):",
  Db.AlbumsTable.query->where(c =>
    Expr.or_([Expr.eq(c.album.year, value(1982)), Expr.eq(c.album.year, value(1992))])
  ),
)

log(
  "get albums of year 1982 or 1992 (IN):",
  Db.AlbumsTable.query->where(c => Expr.in_(c.album.year, [value(1982), value(1992)])),
)

log(
  "get all albums with songs (exclude empty albums):",
  Db.AlbumsInnerJoinSongs.query->join(0, c => Expr.eq(c.song.albumId, c.album.id)),
)

log(
  "get all albums which are newer than 'Fear of the Dark' (join):",
  Db.AlbumsInnerJoinAlbums.query
  ->join(0, c => Expr.eq(c.a2.name, value("Fear of the Dark")))
  ->where(c => Expr.gt(c.a1.year, c.a2.year)),
)

log(
  "get all albums which are newer than 'Fear of the Dark' (subquery):",
  Db.AlbumsTable.query->where(c =>
    Expr.gt(
      c.album.year,
      subQuery(
        Db.AlbumsTable.query
        ->where(c => Expr.eq(c.album.name, value("Fear of the Dark")))
        ->select(c => {"result": {"year": c.album.year}}),
      ),
    )
  ),
)

let avgDurationQuery =
  Db.SongsTable.query->select(c => {"song": {"avgDuration": c.song.duration->avg->unbox}})

log("get avg song duration:", avgDurationQuery)

log(
  "get all songs which are longer then the avg:",
  Db.SongsTable.query->where(c => Expr.gt(c.song.duration, subQuery(avgDurationQuery))),
)

log(
  "get songs with duration between 1 and 2 minutes:",
  Db.SongsTable.query->where(c => Expr.btw(c.song.duration, value("1:00"), value("2:00"))),
)

log(
  "get number of albums per artist:",
  Db.ArtistsLeftJoinAlbums.query
  ->join(0, c => Expr.eq(c.album.artistId, c.artist.id))
  ->groupBy(c => [GroupBy.group(c.album.artistId)])
  ->select(c =>
    {"result": {"artistName": c.artist.name->unbox, "albumCount": c.album.id->count->unbox}}
  ),
)

log(
  "get number of albums per artist (but only artists with less than 4 albums):",
  Db.ArtistsLeftJoinAlbums.query
  ->join(0, c => Expr.eq(c.album.artistId, c.artist.id))
  ->groupBy(c => [GroupBy.group(c.album.artistId)])
  ->having(c => Expr.lt(count(c.album.id), value(4)))
  ->select(c =>
    {"result": {"artistName": c.artist.name->unbox, "albumCount": c.album.id->count->unbox}}
  ),
)

let getEverything =
  Db.ArtistsLeftJoinAlbumsLeftJoinSongs.query
  ->join(0, c => Expr.eq(c.album.artistId, c.artist.id))
  ->join(1, c => Expr.eq(c.song.albumId, c.album.id))

log("get all artists with it's albums with it's songs:", getEverything)

let result = getEverything->execute(db)

open! JsArray2Ex

result->inspect
result
->groupBy(row => row["artist"])
->map(((artist, rows)) =>
  {
    "artist": artist["name"],
    "albums": rows
    ->filter(row => row["album"]["id"] !== None)
    ->groupBy(row => row["album"])
    ->map(((album, rows)) =>
      {
        "album": album["name"],
        "songs": rows->filter(row => row["song"]["id"] !== None)->map(row => row["song"]["name"]),
      }
    ),
  }
)
->inspect
