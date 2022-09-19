open DB

let insertArtists = db => {
  open DML.Insert

  let query = ArtistsTable.Insert.makeQuery([
    {name: "Architects"},
    {name: "While She Sleeps"},
    {name: "Misfits"},
    {name: "Iron Maiden"},
  ])

  Logger.log("insert artists", query->toSQL)

  query->execute(db)
}

let insertAlbums = db => {
  open DML.Insert

  let query = AlbumsTable.Insert.makeQuery([
    {artistId: 1, name: "Hollow Crown", year: 2009},
    {artistId: 1, name: "Lost Forever / Lost Together", year: 2014},
    {artistId: 2, name: "This Is the Six", year: 2012},
    {artistId: 2, name: "Brainwashed", year: 2015},
    {artistId: 2, name: "You Are We", year: 2017},
    {artistId: 2, name: "So What?", year: 2019},
    {artistId: 3, name: "Static Age", year: 1978},
    {artistId: 3, name: "Walk Among Us", year: 1982},
    {artistId: 3, name: "American Psycho", year: 1997},
    {artistId: 4, name: "Iron Maiden", year: 1980},
    {artistId: 4, name: "The Number of the Beast", year: 1982},
    {artistId: 4, name: "Fear of the Dark", year: 1992},
  ])

  Logger.log("insert artists", query->toSQL)

  query->execute(db)
}

let insertSongs = db => {
  open DML.Insert

  let query = SongsTable.Insert.makeQuery([
    {albumId: 1, name: "Early Grave", duration: "3:32"},
    {albumId: 1, name: "Dethroned", duration: "3:06"},
    {albumId: 1, name: "Numbers Count for Nothing", duration: "3:50"},
    {albumId: 1, name: "Follow the Water", duration: "3:40"},
    {albumId: 1, name: "In Elegance", duration: "4:16"},
    {albumId: 1, name: "We're All Alone", duration: "3:01"},
    {albumId: 1, name: "Borrowed Time", duration: "2:30"},
    {albumId: 1, name: "Every Last Breath", duration: "3:28"},
    {albumId: 1, name: "One of These Days", duration: "2:34"},
    {albumId: 1, name: "Dead March", duration: "3:47"},
    {albumId: 1, name: "Left with a Last Minute", duration: "2:57"},
    {albumId: 1, name: "Hollow Crown", duration: "4:24"},
    {albumId: 2, name: "Gravedigger", duration: "4:05"},
    {albumId: 2, name: "Naysayer", duration: "3:25"},
    {albumId: 2, name: "Broken Cross", duration: "3:52"},
    {albumId: 2, name: "The Devil Is Near", duration: "3:35"},
    {albumId: 2, name: "Dead Man Talking", duration: "4:04"},
    {albumId: 2, name: "Red Hypergiant", duration: "2:13"},
    {albumId: 2, name: "C.A.N.C.E.R", duration: "4:19"},
    {albumId: 2, name: "Colony Collapse", duration: "4:31"},
    {albumId: 2, name: "Castles in the Air", duration: "3:42"},
    {albumId: 2, name: "Youth Is Wasted on the Young", duration: "4:23"},
    {albumId: 2, name: "The Distant Blue", duration: "5:13"},
    {albumId: 3, name: "Dead Behind the Eyes", duration: "4:04"},
    {albumId: 3, name: "False Freedom", duration: "3:47"},
    {albumId: 3, name: "Satisfied in Suffering", duration: "3:13"},
    {albumId: 3, name: "Seven Hills", duration: "4:20"},
    {albumId: 3, name: "Our Courage, Our Cancer", duration: "3:34"},
    {albumId: 3, name: "This Is the Six", duration: "4:44"},
    {albumId: 3, name: "The Chapel", duration: "2:15"},
    {albumId: 3, name: "Be(lie)ve", duration: "3:54"},
    {albumId: 3, name: "Until the Death", duration: "4:26"},
    {albumId: 3, name: "Love at War", duration: "4:43"},
    {albumId: 3, name: "The Plague of a New Age", duration: "4:18"},
    {albumId: 3, name: "Reunite", duration: "1:14"},
    {albumId: 4, name: "The Divide", duration: "0:52"},
    {albumId: 4, name: "New World Torture", duration: "4:40"},
    {albumId: 4, name: "Brainwashed", duration: "3:28"},
    {albumId: 4, name: "Our Legacy", duration: "4:07"},
    {albumId: 4, name: "Four Walls", duration: "5:07"},
    {albumId: 4, name: "Torment", duration: "3:48"},
    {albumId: 4, name: "Kangaezu Ni", duration: "1:21"},
    {albumId: 4, name: "Life in Tension", duration: "3:41"},
    {albumId: 4, name: "Trophies of Violence", duration: "5:01"},
    {albumId: 4, name: "No Sides, No Enemies", duration: "5:05"},
    {albumId: 4, name: "Method in Madness", duration: "3:54"},
    {albumId: 4, name: "Modern Minds", duration: "4:49"},
    {albumId: 5, name: "You Are We", duration: "4:47"},
    {albumId: 5, name: "Steal the Sun", duration: "4:37"},
    {albumId: 5, name: "Feel", duration: "4:39"},
    {albumId: 5, name: "Empire of Silence", duration: "4:23"},
    {albumId: 5, name: "Wide Awake", duration: "5:04"},
    {albumId: 5, name: "Silence Speaks", duration: "4:55"},
    {albumId: 5, name: "Settle Down Society", duration: "4:56"},
    {albumId: 5, name: "Hurricane", duration: "4:43"},
    {albumId: 5, name: "Revolt", duration: "3:57"},
    {albumId: 5, name: "Civil Isolation", duration: "4:22"},
    {albumId: 5, name: "In Another Now", duration: "4:35"},
    {albumId: 6, name: "Anti-Social", duration: "4:14"},
    {albumId: 6, name: "I've Seen It All", duration: "4:12"},
    {albumId: 6, name: "Inspire", duration: "4:10"},
    {albumId: 6, name: "So What?", duration: "4:32"},
    {albumId: 6, name: "The Guilty Party", duration: "4:26"},
    {albumId: 6, name: "Haunt Me", duration: "4:31"},
    {albumId: 6, name: "Elephant", duration: "4:38"},
    {albumId: 6, name: "Set You Free", duration: "4:17"},
    {albumId: 6, name: "Good Grief", duration: "3:38"},
    {albumId: 6, name: "Back of My Mind", duration: "4:27"},
    {albumId: 6, name: "Gates of Paradise", duration: "5:20"},
    {albumId: 7, name: "Static Age", duration: "1:47"},
    {albumId: 7, name: "TV Casualty", duration: "2:24"},
    {albumId: 7, name: "Some Kinda Hate", duration: "2:02"},
    {albumId: 7, name: "Last Caress", duration: "1:57"},
    {albumId: 7, name: "Return of the Fly", duration: "1:37"},
    {albumId: 7, name: "Hybrid Moments", duration: "1:42"},
    {albumId: 7, name: "We Are 138", duration: "1:41"},
    {albumId: 7, name: "Teenagers from Mars", duration: "2:51"},
    {albumId: 7, name: "Come Back", duration: "5:00"},
    {albumId: 7, name: "Angelfuck", duration: "1:38"},
    {albumId: 7, name: "Hollywood Babylon", duration: "2:20"},
    {albumId: 7, name: "Attitude", duration: "1:31"},
    {albumId: 7, name: "Bullet", duration: "1:38"},
    {albumId: 7, name: "Theme for a Jackal", duration: "2:41"},
    {albumId: 7, name: "She", duration: "1:24"},
    {albumId: 7, name: "Spinal Remains", duration: "1:27"},
    {albumId: 7, name: "In the Doorway", duration: "1:25"},
    {albumId: 8, name: "20 Eyes", duration: "1:41"},
    {albumId: 8, name: "I Turned into a Martian", duration: "1:41"},
    {albumId: 8, name: "All Hell Breaks Loose", duration: "1:47"},
    {albumId: 8, name: "Vampira", duration: "1:26"},
    {albumId: 8, name: "Nike-A-Go-Go", duration: "2:16"},
    {albumId: 8, name: "Hate Breeders", duration: "3:08"},
    {albumId: 8, name: "Mommy, Can I Go Out and Kill Tonight?", duration: "2:01"},
    {albumId: 8, name: "Night of the Living Dead", duration: "1:57"},
    {albumId: 8, name: "Skulls", duration: "2:00"},
    {albumId: 8, name: "Violent World", duration: "1:46"},
    {albumId: 8, name: "Devils Whorehouse", duration: "1:45"},
    {albumId: 8, name: "Astro Zombies", duration: "2:14"},
    {albumId: 8, name: "Braineaters", duration: "0:56"},
    {albumId: 9, name: "Abominable Dr. Phibes", duration: "1:41"},
    {albumId: 9, name: "American Psycho", duration: "2:06"},
    {albumId: 9, name: "Speak of the Devil", duration: "1:47"},
    {albumId: 9, name: "Walk Among Us", duration: "1:23"},
    {albumId: 9, name: "The Hunger", duration: "1:43"},
    {albumId: 9, name: "From Hell They Came", duration: "2:16"},
    {albumId: 9, name: "Dig Up Her Bones", duration: "3:01"},
    {albumId: 9, name: "Blacklight", duration: "1:27"},
    {albumId: 9, name: "Resurrection", duration: "1:29"},
    {albumId: 9, name: "This Island Earth", duration: "2:15"},
    {albumId: 9, name: "Crimson Ghost", duration: "2:01"},
    {albumId: 9, name: "Day of the Dead", duration: "2:49"},
    {albumId: 9, name: "The Haunting", duration: "1:25"},
    {albumId: 9, name: "Mars Attacks", duration: "2:28"},
    {albumId: 9, name: "Hate the Living, Love the Dead", duration: "2:36"},
    {albumId: 9, name: "Shining", duration: "2:59"},
    {albumId: 9, name: "Don't Open 'Til Doomsday + Hell Night", duration: "8:58"},
  ])

  Logger.log("insert artists", query->toSQL)

  query->execute(db)
}

let updateArtist1 = db => {
  open DML.Update

  let query =
    ArtistsTable.Update.makeQuery({name: "Test"})->where(c =>
      Expr.eq(c.id->DQL.column, 1->DQL.value)
    )

  Logger.log("update artist", query->toSQL)

  query->execute(db)
}
