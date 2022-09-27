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
        autoIncrement: true,
        default: None,
      },
      name: {
        table: "artists",
        name: "name",
        dt: "VARCHAR",
        size: Some(100),
        nullable: false,
        unique: true,
        autoIncrement: false,
        default: None,
      },
    },
  }

  module Create = {
    let makeQuery = () => {
      DDL.Create.Query.make(table)
    }
  }

  module Drop = {
    let makeQuery = () => {
      DDL.Drop.Query.make(table)
    }
  }

  module Select = {
    type t = {
      id: int,
      name: string,
    }

    let makeQuery = () => {
      let from = DQL.From.make(table.name, None)

      DQL.Query.make(from, None, table.columns, table.columns)->DQL.select(c => {
        id: c.id->DQL.column->DQL.u,
        name: c.name->DQL.column->DQL.u,
      })
    }
  }

  module Insert = {
    type t = {
      name: string,
    }

    let makeQuery = (): DML.Insert.Query.t<t> => {
      DML.Insert.Query.make(table.name)
    }
  }

  module Update = {
    type t = {
      id?: int,
      name?: string,
    }

    let makeQuery = (): DML.Update.Query.t<t, columns> => {
      DML.Update.Query.make(table.name, table.columns)
    }
  }

  module Delete = {
    let makeQuery = () => {
      DML.Delete.Query.make(table.name, table.columns)
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
        autoIncrement: true,
        default: None,
      },
      artistId: {
        table: "albums",
        name: "artistId",
        dt: "INTEGER",
        size: None,
        nullable: false,
        unique: false,
        autoIncrement: false,
        default: None,
      },
      name: {
        table: "albums",
        name: "name",
        dt: "VARCHAR",
        size: Some(100),
        nullable: false,
        unique: false,
        autoIncrement: false,
        default: None,
      },
      year: {
        table: "albums",
        name: "year",
        dt: "INTEGER",
        size: None,
        nullable: false,
        unique: false,
        autoIncrement: false,
        default: None,
      },
    },
  }

  module Create = {
    let makeQuery = () => {
      DDL.Create.Query.make(table)
    }
  }

  module Drop = {
    let makeQuery = () => {
      DDL.Drop.Query.make(table)
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

  module Insert = {
    type t = {
      artistId: int,
      name: string,
      year: int,
    }

    let makeQuery = (): DML.Insert.Query.t<t> => {
      DML.Insert.Query.make(table.name)
    }
  }

  module Update = {
    type t = {
      id?: int,
      artistId?: int,
      name?: string,
      year?: int,
    }

    let makeQuery = (): DML.Update.Query.t<t, columns> => {
      DML.Update.Query.make(table.name, table.columns)
    }
  }

  module Delete = {
    let makeQuery = () => {
      DML.Delete.Query.make(table.name, table.columns)
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
        autoIncrement: true,
        default: None,
      },
      albumId: {
        table: "songs",
        name: "albumId",
        dt: "INTEGER",
        size: None,
        nullable: false,
        unique: false,
        autoIncrement: false,
        default: None,
      },
      name: {
        table: "songs",
        name: "name",
        dt: "VARCHAR",
        size: Some(100),
        nullable: false,
        unique: false,
        autoIncrement: false,
        default: None,
      },
      duration: {
        table: "songs",
        name: "duration",
        dt: "VARCHAR",
        size: Some(10),
        nullable: false,
        unique: false,
        autoIncrement: false,
        default: None,
      },
    },
  }

  module Create = {
    let makeQuery = () => {
      DDL.Create.Query.make(table)
    }
  }

  module Drop = {
    let makeQuery = () => {
      DDL.Drop.Query.make(table)
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
      let from = DQL.From.make(table.name, None)

      DQL.Query.make(from, None, table.columns, table.columns)->DQL.select(c => {
        id: c.id->DQL.column->DQL.u,
        albumId: c.albumId->DQL.column->DQL.u,
        name: c.name->DQL.column->DQL.u,
        duration: c.duration->DQL.column->DQL.u,
      })
    }
  }

  module Insert = {
    type t = {
      albumId: int,
      name: string,
      duration: string,
    }

    let makeQuery = (): DML.Insert.Query.t<t> => {
      DML.Insert.Query.make(table.name)
    }
  }

  module Update = {
    type t = {
      id?: int,
      albumId?: int,
      name?: string,
      duration?: string,
    }

    let makeQuery = (): DML.Update.Query.t<t, columns> => {
      DML.Update.Query.make(table.name, table.columns)
    }
  }

  module Delete = {
    let makeQuery = () => {
      DML.Delete.Query.make(table.name, table.columns)
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

    let makeQuery = getJoinConditions => {
      let from = DQL.From.make(ArtistsTable.table.name, Some("artist"))
      let projectables: projectables = ColumnsProxy.make()
      let selectables: selectables = ColumnsProxy.make()

      let joinCondition0 = getJoinConditions(selectables)

      let joins = [
        DQL.Join.make(Left, AlbumsTable.table.name, "album", joinCondition0),
      ]

      DQL.Query.make(from, Some(joins), projectables, selectables)->DQL.select(c => {
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

module ArtistsLeftJoinAlbumsLeftJoinSongs = {
  type projectables = {
    artist_id: DDL.Column.t<int>,
    artist_name: DDL.Column.t<string>,
    album_id: DDL.Column.t<option<int>>,
    album_artistId: DDL.Column.t<option<int>>,
    album_name: DDL.Column.t<option<string>>,
    album_year: DDL.Column.t<option<int>>,
    song_id: DDL.Column.t<option<int>>,
    song_albumId: DDL.Column.t<option<int>>,
    song_name: DDL.Column.t<option<string>>,
    song_duration: DDL.Column.t<option<string>>,
  }

  type selectables = {
    artist_id: DDL.Column.t<int>,
    artist_name: DDL.Column.t<string>,
    album_id: DDL.Column.t<int>,
    album_artistId: DDL.Column.t<int>,
    album_name: DDL.Column.t<string>,
    album_year: DDL.Column.t<int>,
    song_id: DDL.Column.t<int>,
    song_albumId: DDL.Column.t<int>,
    song_name: DDL.Column.t<string>,
    song_duration: DDL.Column.t<string>,
  }

  module Select = {
    type t = {
      artist_id: int,
      artist_name: string,
      album_id: option<int>,
      album_artistId: option<int>,
      album_name: option<string>,
      album_year: option<int>,
      song_id: option<int>,
      song_albumId: option<int>,
      song_name: option<string>,
      song_duration: option<string>,
    }

    let makeQuery = getJoinConditions => {
      let from = DQL.From.make(ArtistsTable.table.name, Some("artist"))
      let projectables: projectables = ColumnsProxy.make()
      let selectables: selectables = ColumnsProxy.make()

      let (joinCondition0, joinCondition1) = getJoinConditions(selectables)

      let joins = [
        DQL.Join.make(Left, AlbumsTable.table.name, "album", joinCondition0),
        DQL.Join.make(Left, SongsTable.table.name, "song", joinCondition1),
      ]

      DQL.Query.make(from, Some(joins), projectables, selectables)->DQL.select(c => {
        artist_id: c.artist_id->DQL.column->DQL.u,
        artist_name: c.artist_name->DQL.column->DQL.u,
        album_id: c.album_id->DQL.column->DQL.u,
        album_artistId: c.album_artistId->DQL.column->DQL.u,
        album_name: c.album_name->DQL.column->DQL.u,
        album_year: c.album_year->DQL.column->DQL.u,
        song_id: c.song_id->DQL.column->DQL.u,
        song_albumId: c.song_albumId->DQL.column->DQL.u,
        song_name: c.song_name->DQL.column->DQL.u,
        song_duration: c.song_duration->DQL.column->DQL.u,
      })
    }
  }
}
