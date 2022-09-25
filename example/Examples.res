let example = async () => {
  try {
    let connection = SQLite3.createConnection(":memory:")
    let get = SQLite.get
    let execute = SQLite.execute

    (await DDLExample.createArtistsTable(execute, connection))->Js.log
    Js.log("")

    (await DDLExample.createAlbumsTable(execute, connection))->Js.log
    Js.log("")

    (await DDLExample.createSongsTable(execute, connection))->Js.log
    Js.log("")

    (await DMLExample.insertArtists(execute, connection))->Js.log
    Js.log("")

    (await DMLExample.insertAlbums(execute, connection))->Js.log
    Js.log("")

    (await DMLExample.insertSongs(execute, connection))->Js.log
    Js.log("")

    (await DMLExample.updateTestArtist(execute, connection))->Js.log
    Js.log("")

    (await DMLExample.deleteTESTArtist(execute, connection))->Js.log
    Js.log("")

    (await DQLExample.selectAllArtists(get, connection))->Js.log
    Js.log("")

    (await DQLExample.selectArtistNames(get, connection))->Js.log
    Js.log("")

    (await DQLExample.selectAllArtistsAndRenameColumns(get, connection))->Js.log
    Js.log("")

    (await DQLExample.selectAllArtistsInOrder(get, connection))->Js.log
    Js.log("")

    (await DQLExample.selectArtistWithId1(get, connection))->Js.log
    Js.log("")

    (await DQLExample.selectSong11To20(get, connection))->Js.log
    Js.log("")

    (await DQLExample.selectMaxIdOfArtists(get, connection))->Js.log
    Js.log("")

    (await DQLExample.selectYearsWithMoreThan1Album(get, connection))->Js.log
    Js.log("")

    (await DQLExample.selectArtistsWithAlbums(get, connection))->Js.log
    Js.log("")
  } catch {
  | Errors.SyntaxError(error) => Js.log("Error: " ++ error)
  }
}

example()->ignore

/* let test = async () => { */
/* await MySQL2.createConnection({ */
/* host: "localhost", */
/* user: "root", */
/* password: "password", */
/* database: "rescript" */
/* })->Js.log */
/* } */

/* test()->ignore */
