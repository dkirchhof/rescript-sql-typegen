open DB
open DQL

let selectAllArtists = (get, connection) => {
  let query = ArtistsTable.Select.makeQuery()

  Logger.log("default select query", query->toSQL)

  query->execute(get, connection)
}

type onlyArtistName = {name: string}

let selectArtistNames = (get, connection) => {
  let query = ArtistsTable.Select.makeQuery()->select(c => {name: c.name->DQL.column->u})

  Logger.log("simple projection", query->toSQL)

  query->execute(get, connection)
}

let selectAllArtistsAndRenameColumns = (get, connection) => {
  let query =
    ArtistsTable.Select.makeQuery()->select(c =>
      {"myId": c.id->DQL.column->u, "myName": c.name->DQL.column->u}
    )

  Logger.log("rename columns", query->toSQL)

  query->execute(get, connection)
}

let selectAllArtistsInOrder = (get, connection) => {
  let query = ArtistsTable.Select.makeQuery()->orderBy(c => [c.name->DQL.column->asc])

  Logger.log("change order", query->toSQL)

  query->execute(get, connection)
}

let selectArtistWithId1 = (get, connection) => {
  let query = ArtistsTable.Select.makeQuery()->where(c => Expr.eq(c.id->DQL.column, 1->DQL.value))

  Logger.log("simple selection", query->toSQL)

  query->execute(get, connection)
}

let selectSong11To20 = (get, connection) => {
  let query = SongsTable.Select.makeQuery()->offset(10)->limit(10)

  Logger.log("pagination", query->toSQL)

  query->execute(get, connection)
}

let selectMaxIdOfArtists = (get, connection) => {
  let query = ArtistsTable.Select.makeQuery()->select(c => {"maxId": c.id->DQL.column->DQL.max->u})

  Logger.log("aggregation", query->toSQL)

  query->execute(get, connection)
}

let selectYearsWithMoreThan1Album = (get, connection) => {
  let query =
    AlbumsTable.Select.makeQuery()
    ->select(c => {"year": c.year->DQL.column->u, "numberOfAlbums": c.id->DQL.column->DQL.count->u})
    ->groupBy(c => [c.year->DQL.column->group])
    ->having(c => Expr.gt(c.id->DQL.column->DQL.count, 1->DQL.value))

  Logger.log("grouping", query->toSQL)

  query->execute(get, connection)
}

let selectArtistsWithAlbums = (get, connection) => {
  let query = ArtistsLeftJoinAlbums.Select.makeQuery(c =>
    Expr.eq(c.album_artistId->DQL.column, c.artist_id->DQL.column)
  )

  Logger.log("join", query->toSQL)

  query->execute(get, connection)
}

/* open DB */
/* open QB */

/* let logAndExecute = (title, query, connection) => { */
/* Js.log2(`\x1b[1m%s\x1b[0m`, title) */
/* Js.log(query->toSQL ++ ";") */

/* let result = execute(query, connection) */

/* Js.log(result) */
/* Js.log("") */
/* } */

/* %%raw(` */
/* import { inspect as inspect_ } from "util"; */
/* `) */

/* let inspect = %raw(` */
/* function(value) { */
/* console.log(inspect_(value, false, 10, true)); */
/* } */
/* `) */

/* let db = SQLite3.createDB("db.db") */

/* log( */
/* "get all artist names in alphabetic order:", */
/* ArtistsTable.Select.makeQuery() */
/* ->orderBy(c => [c.artist.name->column->asc]) */
/* ->select(c => {"artist": {"name": c.artist.name->columnU}}), */
/* ) */

/* log( */
/* "get number of songs:", */
/* Songs.makeSelectQuery()->select(c => {"song": {"count": c.song.id->column->countU}}), */
/* ) */

/* log( */
/* "get albums of year 1982 or 1992 (OR):", */
/* Albums.makeSelectQuery()->where(c => */
/* Expr.or_([ */
/* Expr.eq(column(c.album.year), value(1982)), */
/* Expr.eq(column(c.album.year), value(1992)), */
/* ]) */
/* ), */
/* ) */

/* log( */
/* "get albums of year 1982 or 1992 (IN):", */
/* Albums.makeSelectQuery()->where(c => */
/* Expr.in_(column(c.album.year), [value(1982), value(1992)]) */
/* ), */
/* ) */

/* log( */
/* "get all albums with songs (exclude empty albums):", */
/* AlbumsInnerJoinSongs.makeSelectQuery()->join(0, c => */
/* Expr.eq(column(c.song.albumId), column(c.album.id)) */
/* ), */
/* ) */

/* log( */
/* "get all albums which are newer than 'Fear of the Dark' (join):", */
/* AlbumsInnerJoinAlbums.makeSelectQuery() */
/* ->join(0, c => Expr.eq(column(c.a2.name), value("Fear of the Dark"))) */
/* ->where(c => Expr.gt(column(c.a1.year), column(c.a2.year))), */
/* ) */

/* log( */
/* "get all albums which are newer than 'Fear of the Dark' (subquery):", */
/* Albums.makeSelectQuery()->where(c => */
/* Expr.gt( */
/* column(c.album.year), */
/* subQuery( */
/* Albums.makeSelectQuery() */
/* ->where(c => Expr.eq(column(c.album.name), value("Fear of the Dark"))) */
/* ->select(c => {"result": {"year": column(c.album.year)}}), */
/* ), */
/* ) */
/* ), */
/* ) */

/* let avgDurationQuery = */
/* Songs.makeSelectQuery()->select(c => {"song": {"avgDuration": c.song.duration->column->avgU}}) */

/* log("get avg song duration:", avgDurationQuery) */

/* log( */
/* "get all songs which are longer then the avg:", */
/* Songs.makeSelectQuery()->where(c => */
/* Expr.gt(column(c.song.duration), subQuery(avgDurationQuery)) */
/* ), */
/* ) */

/* log( */
/* "get songs with duration between 1 and 2 minutes:", */
/* Songs.makeSelectQuery()->where(c => */
/* Expr.btw(column(c.song.duration), value("1:00"), value("2:00")) */
/* ), */
/* ) */

/* log( */
/* "get number of albums per artist:", */
/* ArtistsLeftJoinAlbums.makeSelectQuery() */
/* ->join(0, c => Expr.eq(column(c.album.artistId), column(c.artist.id))) */
/* ->groupBy(c => [c.album.artistId->column->group]) */
/* ->select(c => */
/* { */
/* "result": { */
/* "artistName": columnU(c.artist.name) */
/* "albumCount": column(c.album.id)->countU */
/* }, */
/* } */
/* ), */
/* ) */

/* log( */
/* "get number of albums per artist (but only artists with less than 4 albums):", */
/* ArtistsLeftJoinAlbums.makeSelectQuery() */
/* ->join(0, c => Expr.eq(column(c.album.artistId), column(c.artist.id))) */
/* ->groupBy(c => [c.album.artistId->column->GroupBy.group]) */
/* ->having(c => Expr.lt(c.album.id->column->count, value(4))) */
/* ->select(c => */
/* { */
/* "result": { */
/* "artistName": columnU(c.artist.name) */
/* "albumCount": column(c.album.id)->countU */
/* }, */
/* } */
/* ), */
/* ) */

/* let getEverything = */
/* ArtistsLeftJoinAlbumsLeftJoinSongs.makeSelectQuery() */
/* ->join(0, c => Expr.eq(column(c.album.artistId), column(c.artist.id))) */
/* ->join(1, c => Expr.eq(column(c.song.albumId), column(c.album.id))) */

/* log("get all artists with it's albums with it's songs:", getEverything) */

/* /1* let result = getEverything->execute(connection) *1/ */

/* /1* open! JsArray2Ex *1/ */

/* /1* result->inspect *1/ */
/* /1* result *1/ */
/* /1* ->groupBy(row => row["artist"]) *1/ */
/* /1* ->map(((artist, rows)) => *1/ */
/* /1* { *1/ */
/* /1* "artist": artist["name"], *1/ */
/* /1* "albums": rows *1/ */
/* /1* ->filter(row => row["album"]["id"] !== None) *1/ */
/* /1* ->groupBy(row => row["album"]) *1/ */
/* /1* ->map(((album, rows)) => *1/ */
/* /1* { *1/ */
/* /1* "album": album["name"], *1/ */
/* /1* "songs": rows->filter(row => row["song"]["id"] !== None)->map(row => row["song"]["name"]), *1/ */
/* /1* } *1/ */
/* /1* ), *1/ */
/* /1* } *1/ */
/* /1* ) *1/ */
/* /1* ->inspect *1/ */
