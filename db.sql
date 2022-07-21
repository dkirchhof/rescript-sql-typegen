CREATE TABLE artists (
  id INTEGER,
  name TEXT
);

CREATE TABLE songs (
  id INTEGER,
  artist INTEGER,
  title TEXT
);

INSERT INTO artists VALUES
  (1, "Architects"),
  (2, "While She Sleeps"),
  (3, "Misfits"),
  (4, "Iron Maiden");
  
INSERT INTO songs VALUES
  (1, 1, "Hollow Crown"),
  (2, 1, "Lost Forever / Lost Together"),

  (3, 2, "This Is the Six"),
  (4, 2, "Brainwashed"),
  (5, 2, "You Are We"),
  (6, 2, "So What?"),

  (7, 3, "Static Age"),
  (8, 3, "Walk Among Us"),
  (9, 3, "American Psycho"),

  (10, 4, "Iron Maiden"),
  (11, 4, "The Number of the Beast"),
  (12, 4, "Fear of the Dark");
