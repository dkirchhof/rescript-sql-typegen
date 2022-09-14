module ArtistsTable = {
  type columns = {
    id: DDL.Column.t<int>,
    name: DDL.Column.t<string>,
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
    getConstraints: columns => [DDL.makePrimaryKey1("PK", columns.id)],
  }

  module Create = {
    let makeQuery = () => {
      DDL.Query.make(table)
    }
  }

  module Select = {
    type t = {
      id: int,
      name: string,
    }

    let makeQuery = () => {
      let from = DQL.From.make("artists", None)

      DQL.Query.make(from, None, table.columns, table.columns)->DQL.select(c => {
        id: c.id->DQL.column->DQL.u,
        name: c.name->DQL.column->DQL.u,
      })
    }
  }
}

module AlbumsTable = {
  type columns = {
    id: DDL.Column.t<int>,
    artistId: DDL.Column.t<int>,
    name: DDL.Column.t<string>,
    year: DDL.Column.t<int>,
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
    getConstraints: columns => [
      DDL.makePrimaryKey1("PK", columns.id),
      DDL.makeForeignKey("FK_Artist", columns.artistId, ArtistsTable.table.columns.id),
    ],
  }

  module Create = {
    let makeQuery = () => {
      DDL.Query.make(table)
    }
  }

  module Select = {
    type t = {
      id: int,
      artistId: int,
      name: string,
      year: int,
    }

    let makeQuery = () => {
      let from = DQL.From.make(table.name, None)

      DQL.Query.make(from, None, table.columns, table.columns)->DQL.select(c => {
        id: c.id->DQL.column->DQL.u,
        artistId: c.artistId->DQL.column->DQL.u,
        name: c.name->DQL.column->DQL.u,
        year: c.year->DQL.column->DQL.u,
      })
    }
  }
}

module SongsTable = {
  type columns = {
    id: DDL.Column.t<int>,
    albumId: DDL.Column.t<int>,
    name: DDL.Column.t<string>,
    duration: DDL.Column.t<string>,
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
    getConstraints: columns => [
      DDL.makePrimaryKey1("PK", columns.id),
      DDL.makeForeignKey("FK_Album", columns.albumId, AlbumsTable.table.columns.id),
    ],
  }

  module Create = {
    let makeQuery = () => {
      DDL.Query.make(table)
    }
  }

  module Select = {
    type t = {
      id: int,
      albumId: int,
      name: string,
      duration: string,
    }

    let makeQuery = () => {
      let from = DQL.From.make("songs", None)

      DQL.Query.make(from, None, table.columns, table.columns)->DQL.select(c => {
        id: c.id->DQL.column->DQL.u,
        albumId: c.albumId->DQL.column->DQL.u,
        name: c.name->DQL.column->DQL.u,
        duration: c.duration->DQL.column->DQL.u,
      })
    }
  }
}

module ArtistsLeftJoinAlbums = {
  type projectables = {
    artist_id: DDL.Column.t<int>,
    artist_name: DDL.Column.t<string>,
    album_id: DDL.Column.t<option<int>>,
    album_artistId: DDL.Column.t<option<int>>,
    album_name: DDL.Column.t<option<string>>,
    album_year: DDL.Column.t<option<int>>,
  }

  type selectables = {
    artist_id: DDL.Column.t<int>,
    artist_name: DDL.Column.t<string>,
    album_id: DDL.Column.t<int>,
    album_artistId: DDL.Column.t<int>,
    album_name: DDL.Column.t<string>,
    album_year: DDL.Column.t<int>,
  }

  module Select = {
    type t = {
      artist_id: int,
      artist_name: string,
      album_id: option<int>,
      album_artistId: option<int>,
      album_name: option<string>,
      album_year: option<int>,
    }

    let makeQuery = (getJoinConditions) => {
      let from = DQL.From.make(ArtistsTable.table.name, Some("artist"))
      let projectables: projectables = Utils.createColumnAccessor()
      let selectables: selectables = Utils.createColumnAccessor()

      let joinCondition1 = getJoinConditions(selectables)
      let joins = [DQL.Join.make(Inner, AlbumsTable.table.name, "album", joinCondition1)]->Some

      DQL.Query.make(from, joins, projectables, selectables)->DQL.select(c => {
        artist_id: c.artist_id->DQL.column->DQL.u,
        artist_name: c.artist_name->DQL.column->DQL.u,
        album_id: c.album_id->DQL.column->DQL.u,
        album_artistId: c.album_artistId->DQL.column->DQL.u,
        album_name: c.album_name->DQL.column->DQL.u,
        album_year: c.album_year->DQL.column->DQL.u,
      })
    }
  }
}

/* module AlbumsInnerJoinAlbums = { */
/* type selectables = { */
/* a1: AlbumsTable.columns, */
/* a2: AlbumsTable.columns, */
/* } */

/* type projectables = { */
/* a1: AlbumsTable.columns, */
/* a2: AlbumsTable.columns, */
/* } */

/* let makeSelectQuery = (): Query.t<projectables, selectables, _> => { */
/* let from = From.make("albums", "a1") */

/* let joins = [Join.make("albums", "a2", Inner)] */

/* Query.makeSelectQuery(from, joins)->QB.select(c => */
/* { */
/* "a1": { */
/* "id": c.a1.id->DQL.column->DQL.u, */
/* "artistId": c.a1.artistId->DQL.column->DQL.u, */
/* "name": c.a1.name->DQL.column->DQL.u, */
/* "year": c.a1.year->DQL.column->DQL.u, */
/* }, */
/* "a2": { */
/* "id": c.a2.id->DQL.column->DQL.u, */
/* "artistId": c.a2.artistId->DQL.column->DQL.u, */
/* "name": c.a2.name->DQL.column->DQL.u, */
/* "year": c.a2.year->DQL.column->DQL.u, */
/* }, */
/* } */
/* ) */
/* } */
/* } */

/* module ArtistsLeftJoinAlbums = { */
/* type selectables = { */
/* artist: ArtistsTable.columns, */
/* album: AlbumsTable.columns, */
/* } */

/* type projectables = { */
/* artist: ArtistsTable.columns, */
/* album: AlbumsTable.optionalColumns, */
/* } */

/* let makeSelectQuery = (): Query.t<projectables, selectables, _> => { */
/* let from = From.make("artists", "artist") */

/* let joins = [Join.make("albums", "album", Left)] */

/* Query.makeSelectQuery(from, joins)->QB.select(c => */
/* { */
/* "artist": { */
/* "id": c.artist.id->DQL.column->DQL.u, */
/* "name": c.artist.name->DQL.column->DQL.u, */
/* }, */
/* "album": { */
/* "id": c.album.id->DQL.column->DQL.u, */
/* "artistId": c.album.artistId->DQL.column->DQL.u, */
/* "name": c.album.name->DQL.column->DQL.u, */
/* "year": c.album.year->DQL.column->DQL.u, */
/* }, */
/* } */
/* ) */
/* } */
/* } */

/* module ArtistsLeftJoinAlbumsLeftJoinSongs = { */
/* type selectables = { */
/* artist: ArtistsTable.columns, */
/* album: AlbumsTable.columns, */
/* song: SongsTable.columns, */
/* } */

/* type projectables = { */
/* artist: ArtistsTable.columns, */
/* album: AlbumsTable.optionalColumns, */
/* song: SongsTable.optionalColumns, */
/* } */

/* let makeSelectQuery = (): Query.t<projectables, selectables, _> => { */
/* let from = From.make("artists", "artist") */

/* let joins = [Join.make("albums", "album", Left), Join.make("songs", "song", Left)] */

/* Query.makeSelectQuery(from, joins)->QB.select(c => */
/* { */
/* "artist": { */
/* "id": c.artist.id->DQL.column->DQL.u, */
/* "name": c.artist.name->DQL.column->DQL.u, */
/* }, */
/* "album": { */
/* "id": c.album.id->DQL.column->DQL.u, */
/* "artistId": c.album.artistId->DQL.column->DQL.u, */
/* "name": c.album.name->DQL.column->DQL.u, */
/* "year": c.album.year->DQL.column->DQL.u, */
/* }, */
/* "song": { */
/* "id": c.song.id->DQL.column->DQL.u, */
/* "albumId": c.song.albumId->DQL.column->DQL.u, */
/* "name": c.song.name->DQL.column->DQL.u, */
/* "duration": c.song.duration->DQL.column->DQL.u, */
/* }, */
/* } */
/* ) */
/* } */
/* } */
