let db = SQLite3.createDB(":memory:")

DDLExample.createArtistsTable(db)
Js.log("")

DDLExample.createAlbumsTable(db)
Js.log("")

DDLExample.createSongsTable(db)
Js.log("")

DMLExample.insertArtists(db)->Js.log
Js.log("")

DMLExample.insertAlbums(db)->Js.log
Js.log("")

DMLExample.insertSongs(db)->Js.log
Js.log("")

DMLExample.updateTestArtist(db)->Js.log
Js.log("")

DMLExample.deleteTESTArtist(db)->Js.log
Js.log("")

DQLExample.selectAllArtists(db)->Js.log
Js.log("")

DQLExample.selectArtistNames(db)->Js.log
Js.log("")

DQLExample.selectAllArtistsAndRenameColumns(db)->Js.log
Js.log("")

DQLExample.selectAllArtistsInOrder(db)->Js.log
Js.log("")

DQLExample.selectArtistWithId1(db)->Js.log
Js.log("")

DQLExample.selectSong11To20(db)->Js.log
Js.log("")

DQLExample.selectMaxIdOfArtists(db)->Js.log
Js.log("")

DQLExample.selectYearsWithMoreThan1Album(db)->Js.log
Js.log("")

DQLExample.selectArtistsWithAlbums(db)->Js.log
Js.log("")
