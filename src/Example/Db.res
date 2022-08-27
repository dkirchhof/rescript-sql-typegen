// generated by makeTableModule
module ArtistsTable = {
  type columns = {
    id: Ref.Typed.t<int>,
    name: Ref.Typed.t<string>,
  }

  type optionalColumns = {
    id: Ref.Typed.t<option<int>>,
    name: Ref.Typed.t<option<string>>,
  }

  type selectables = {artist: columns}
  type projectables = {artist: columns}

  let query: Query.t<projectables, selectables, _> =
    Query.makeSelectQuery("artists", "artist")->QB.select(c =>
      {"artist": {"id": c.artist.id, "name": c.artist.name}}
    )
}

// generated by makeTableModule
module AlbumsTable = {
  type columns = {
    id: Ref.Typed.t<int>,
    artistId: Ref.Typed.t<int>,
    name: Ref.Typed.t<string>,
    year: Ref.Typed.t<int>,
  }

  type optionalColumns = {
    id: Ref.Typed.t<option<int>>,
    name: Ref.Typed.t<option<string>>,
    artistId: Ref.Typed.t<option<int>>,
    year: Ref.Typed.t<option<int>>,
  }

  type selectables = {album: columns}
  type projectables = {album: columns}

  let query: Query.t<projectables, selectables, _> = Query.makeSelectQuery(
    "albums",
    "album",
  )->QB.select(c =>
    {
      "album": {
        "id": c.album.id,
        "artistId": c.album.artistId,
        "name": c.album.name,
        "year": c.album.year,
      },
    }
  )
}

// generated by makeTableModule
module SongsTable = {
  type columns = {
    id: Ref.Typed.t<int>,
    albumId: Ref.Typed.t<int>,
    name: Ref.Typed.t<string>,
    duration: Ref.Typed.t<string>,
  }

  type optionalColumns = {
    id: Ref.Typed.t<option<int>>,
    albumId: Ref.Typed.t<option<int>>,
    name: Ref.Typed.t<option<string>>,
    duration: Ref.Typed.t<string>,
  }

  type selectables = {song: columns}
  type projectables = {song: columns}

  let query: Query.t<projectables, selectables, _> = Query.makeSelectQuery(
    "songs",
    "song",
  )->QB.select(c =>
    {
      "song": {
        "id": c.song.id,
        "albumId": c.song.albumId,
        "name": c.song.name,
        "duration": c.song.duration,
      },
    }
  )
}

// generated by makeQueryModule albums inner join songs
module AlbumsInnerJoinSongs = {
  type selectables = {
    album: AlbumsTable.columns,
    song: SongsTable.columns,
  }

  type projectables = {
    album: AlbumsTable.columns,
    song: SongsTable.columns,
  }

  let query: Query.t<projectables, selectables, _> = {
    ...Query.makeSelectQuery("albums", "album"),
    joins: [{table: {name: "songs", alias: "song"}, joinType: Left, condition: None}],
  }->QB.select(c =>
    {
      "album": {
        "id": c.album.id,
        "artistId": c.album.artistId,
        "name": c.album.name,
        "year": c.album.year,
      },
      "song": {
        "id": c.song.id,
        "albumId": c.song.albumId,
        "name": c.song.name,
        "duration": c.song.duration,
      },
    }
  )
}

// generated by makeQueryModule albums inner join albums
module AlbumsInnerJoinAlbums = {
  type selectables = {
    a1: AlbumsTable.columns,
    a2: AlbumsTable.columns,
  }

  type projectables = {
    a1: AlbumsTable.columns,
    a2: AlbumsTable.columns,
  }

  let query: Query.t<projectables, selectables, _> = {
    ...Query.makeSelectQuery("albums", "a1"),
    joins: [{table: {name: "albums", alias: "a2"}, joinType: Inner, condition: None}],
  }->QB.select(c =>
    {
      "a1": {
        "id": c.a1.id,
        "artistId": c.a1.artistId,
        "name": c.a1.name,
        "year": c.a1.year,
      },
      "a2": {
        "id": c.a2.id,
        "artistId": c.a2.artistId,
        "name": c.a2.name,
        "year": c.a2.year,
      },
    }
  )
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

  let query: Query.t<projectables, selectables, _> = {
    ...Query.makeSelectQuery("artists", "artist"),
    joins: [{table: {name: "albums", alias: "album"}, joinType: Left, condition: None}],
  }->QB.select(c =>
    {
      "artist": {"id": c.artist.id, "name": c.artist.name},
      "album": {
        "id": c.album.id,
        "artistId": c.album.artistId,
        "name": c.album.name,
        "year": c.album.year,
      },
    }
  )
}

// generated by makeQueryModule artists left join albums left join songs
// makeQueryModule(From(ArtistsTable, "ar"), [LeftJoin(AlbumsTable, "al", ("ar", ArtistsTable.id), ("al", AlbumsTable.artistId))])
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

  let query: Query.t<projectables, selectables, _> = {
    ...Query.makeSelectQuery("artists", "artist"),
    joins: [
      {table: {name: "albums", alias: "album"}, joinType: Left, condition: None},
      {table: {name: "songs", alias: "song"}, joinType: Left, condition: None},
    ],
  }->QB.select(c =>
    {
      "artist": {"id": c.artist.id, "name": c.artist.name},
      "album": {
        "id": c.album.id->QB.unbox,
        "artistId": c.album.artistId->QB.unbox,
        "name": c.album.name->QB.unbox,
        "year": c.album.year->QB.unbox,
      },
      "song": {
        "id": c.song.id->QB.unbox,
        "albumId": c.song.albumId->QB.unbox,
        "name": c.song.name->QB.unbox,
        "duration": c.song.duration->QB.unbox,
      },
    }
  )
}