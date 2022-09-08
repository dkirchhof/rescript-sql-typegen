module ArtistsTable = {
  type columns = {
    id: DDL.Column.t<int>,
    name: DDL.Column.t<string>,
  }

  type optionalColumns = {
    id: DDL.Column.t<option<int>>,
    name: DDL.Column.t<option<string>>,
  }

  let table: DDL.Table.t<columns> = {
    name: "artists",
    columns: {
      id: {
        table: "artists",
        name: "id",
        dt: "INTEGER",
        size: None,
        nullable: false,
        unique: false,
        default: None,
      },
      name: {
        table: "artists",
        name: "name",
        dt: "TEXT",
        size: None,
        nullable: false,
        unique: true,
        default: None,
      },
    },
  }
}

module AlbumsTable = {
  type columns = {
    id: DDL.Column.t<int>,
    artistId: DDL.Column.t<int>,
    name: DDL.Column.t<string>,
    year: DDL.Column.t<int>,
  }

  type optionalColumns = {
    id: DDL.Column.t<option<int>>,
    artistId: DDL.Column.t<option<int>>,
    name: DDL.Column.t<option<string>>,
    year: DDL.Column.t<option<int>>,
  }

  let table: DDL.Table.t<columns> = {
    name: "albums",
    columns: {
      id: {
        table: "albums",
        name: "id",
        dt: "INTEGER",
        size: None,
        nullable: false,
        unique: false,
        default: None,
      },
      artistId: {
        table: "albums",
        name: "artistId",
        dt: "INTEGER",
        size: None,
        nullable: false,
        unique: false,
        default: None,
      },
      name: {
        table: "albums",
        name: "name",
        dt: "TEXT",
        size: None,
        nullable: false,
        unique: false,
        default: None,
      },
      year: {
        table: "albums",
        name: "year",
        dt: "INTEGER",
        size: None,
        nullable: false,
        unique: false,
        default: None,
      },
    },
  }
}

module SongsTable = {
  type columns = {
    id: DDL.Column.t<int>,
    albumId: DDL.Column.t<int>,
    name: DDL.Column.t<string>,
    duration: DDL.Column.t<string>,
  }

  type optionalColumns = {
    id: DDL.Column.t<option<int>>,
    albumId: DDL.Column.t<option<int>>,
    name: DDL.Column.t<option<string>>,
    duration: DDL.Column.t<option<string>>,
  }

  let table: DDL.Table.t<columns> = {
    name: "songs",
    columns: {
      id: {
        table: "songs",
        name: "id",
        dt: "INTEGER",
        size: None,
        nullable: false,
        unique: false,
        default: None,
      },
      albumId: {
        table: "songs",
        name: "albumId",
        dt: "INTEGER",
        size: None,
        nullable: false,
        unique: false,
        default: None,
      },
      name: {
        table: "songs",
        name: "name",
        dt: "TEXT",
        size: None,
        nullable: false,
        unique: false,
        default: None,
      },
      duration: {
        table: "songs",
        name: "duration",
        dt: "TEXT",
        size: None,
        nullable: false,
        unique: false,
        default: None,
      },
    },
  }
}

module Artists = {
  type selectables = {
    artist: ArtistsTable.columns,
  }

  type projectables = {
    artist: ArtistsTable.columns,
  }

  let makeSelectQuery = (): Query.t<projectables, selectables, _> => {
    let from = From.make("artists", "artist")

    let joins = [
    ]

    Query.makeSelectQuery(from, joins)->QB.select(c =>
      {
        "artist": {
          "id": c.artist.id->QB.columnU,
          "name": c.artist.name->QB.columnU,
        },
      }
    )
  }
}

module Albums = {
  type selectables = {
    album: AlbumsTable.columns,
  }

  type projectables = {
    album: AlbumsTable.columns,
  }

  let makeSelectQuery = (): Query.t<projectables, selectables, _> => {
    let from = From.make("albums", "album")

    let joins = [
    ]

    Query.makeSelectQuery(from, joins)->QB.select(c =>
      {
        "album": {
          "id": c.album.id->QB.columnU,
          "artistId": c.album.artistId->QB.columnU,
          "name": c.album.name->QB.columnU,
          "year": c.album.year->QB.columnU,
        },
      }
    )
  }
}

module Songs = {
  type selectables = {
    song: SongsTable.columns,
  }

  type projectables = {
    song: SongsTable.columns,
  }

  let makeSelectQuery = (): Query.t<projectables, selectables, _> => {
    let from = From.make("songs", "song")

    let joins = [
    ]

    Query.makeSelectQuery(from, joins)->QB.select(c =>
      {
        "song": {
          "id": c.song.id->QB.columnU,
          "albumId": c.song.albumId->QB.columnU,
          "name": c.song.name->QB.columnU,
          "duration": c.song.duration->QB.columnU,
        },
      }
    )
  }
}

module AlbumsInnerJoinSongs = {
  type selectables = {
    album: AlbumsTable.columns,
    song: SongsTable.columns,
  }

  type projectables = {
    album: AlbumsTable.columns,
    song: SongsTable.columns,
  }

  let makeSelectQuery = (): Query.t<projectables, selectables, _> => {
    let from = From.make("albums", "album")

    let joins = [
      Join.make("songs", "song", Inner),
    ]

    Query.makeSelectQuery(from, joins)->QB.select(c =>
      {
        "album": {
          "id": c.album.id->QB.columnU,
          "artistId": c.album.artistId->QB.columnU,
          "name": c.album.name->QB.columnU,
          "year": c.album.year->QB.columnU,
        },
        "song": {
          "id": c.song.id->QB.columnU,
          "albumId": c.song.albumId->QB.columnU,
          "name": c.song.name->QB.columnU,
          "duration": c.song.duration->QB.columnU,
        },
      }
    )
  }
}

module AlbumsInnerJoinAlbums = {
  type selectables = {
    a1: AlbumsTable.columns,
    a2: AlbumsTable.columns,
  }

  type projectables = {
    a1: AlbumsTable.columns,
    a2: AlbumsTable.columns,
  }

  let makeSelectQuery = (): Query.t<projectables, selectables, _> => {
    let from = From.make("albums", "a1")

    let joins = [
      Join.make("albums", "a2", Inner),
    ]

    Query.makeSelectQuery(from, joins)->QB.select(c =>
      {
        "a1": {
          "id": c.a1.id->QB.columnU,
          "artistId": c.a1.artistId->QB.columnU,
          "name": c.a1.name->QB.columnU,
          "year": c.a1.year->QB.columnU,
        },
        "a2": {
          "id": c.a2.id->QB.columnU,
          "artistId": c.a2.artistId->QB.columnU,
          "name": c.a2.name->QB.columnU,
          "year": c.a2.year->QB.columnU,
        },
      }
    )
  }
}

module ArtistsLeftJoinAlbums = {
  type selectables = {
    artist: ArtistsTable.columns,
    album: AlbumsTable.columns,
  }

  type projectables = {
    artist: ArtistsTable.columns,
    album: AlbumsTable.optionalColumns,
  }

  let makeSelectQuery = (): Query.t<projectables, selectables, _> => {
    let from = From.make("artists", "artist")

    let joins = [
      Join.make("albums", "album", Left),
    ]

    Query.makeSelectQuery(from, joins)->QB.select(c =>
      {
        "artist": {
          "id": c.artist.id->QB.columnU,
          "name": c.artist.name->QB.columnU,
        },
        "album": {
          "id": c.album.id->QB.columnU,
          "artistId": c.album.artistId->QB.columnU,
          "name": c.album.name->QB.columnU,
          "year": c.album.year->QB.columnU,
        },
      }
    )
  }
}

module ArtistsLeftJoinAlbumsLeftJoinSongs = {
  type selectables = {
    artist: ArtistsTable.columns,
    album: AlbumsTable.columns,
    song: SongsTable.columns,
  }

  type projectables = {
    artist: ArtistsTable.columns,
    album: AlbumsTable.optionalColumns,
    song: SongsTable.optionalColumns,
  }

  let makeSelectQuery = (): Query.t<projectables, selectables, _> => {
    let from = From.make("artists", "artist")

    let joins = [
      Join.make("albums", "album", Left),
      Join.make("songs", "song", Left),
    ]

    Query.makeSelectQuery(from, joins)->QB.select(c =>
      {
        "artist": {
          "id": c.artist.id->QB.columnU,
          "name": c.artist.name->QB.columnU,
        },
        "album": {
          "id": c.album.id->QB.columnU,
          "artistId": c.album.artistId->QB.columnU,
          "name": c.album.name->QB.columnU,
          "year": c.album.year->QB.columnU,
        },
        "song": {
          "id": c.song.id->QB.columnU,
          "albumId": c.song.albumId->QB.columnU,
          "name": c.song.name->QB.columnU,
          "duration": c.song.duration->QB.columnU,
        },
      }
    )
  }
}
