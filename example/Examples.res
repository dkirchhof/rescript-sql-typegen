let example = async () => {
  try {
    /* let connection = SQLite3.createConnection(":memory:") */
    /* let get = SQLite.get */
    /* let execute = SQLite.execute */

    let connection = await MySQL2.createConnection({
      host: "localhost",
      user: "root",
      password: "password",
      database: "rescript",
    })

    let get = MySQLProvider.get
    let mutate = MySQLProvider.mutate

    (await DDLExample.createArtistsTable(mutate, connection))->Js.log
    Js.log("")

    (await DDLExample.createAlbumsTable(mutate, connection))->Js.log
    Js.log("")

    (await DDLExample.createSongsTable(mutate, connection))->Js.log
    Js.log("")

    (await DMLExample.insertArtists(mutate, connection))->Js.log
    Js.log("")

    (await DMLExample.insertAlbums(mutate, connection))->Js.log
    Js.log("")

    (await DMLExample.insertSongs(mutate, connection))->Js.log
    Js.log("")

    (await DMLExample.updateTestArtist(mutate, connection))->Js.log
    Js.log("")

    (await DMLExample.deleteTESTArtist(mutate, connection))->Js.log
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

    (await DDLExample.dropSongsTable(mutate, connection))->Js.log
    Js.log("")

    (await DDLExample.dropAlbumsTable(mutate, connection))->Js.log
    Js.log("")

    (await DDLExample.dropArtistsTable(mutate, connection))->Js.log
    Js.log("")
  } catch {
  | Js.Exn.Error(obj) =>
    obj
    ->Js.Exn.message
    ->Belt.Option.getWithDefault("")
    ->(message => Js.log("DB ERROR: " ++ message))
  }
}

example()->ignore
