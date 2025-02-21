import 'package:sqflite/sqflite.dart';

class MoviesDB {
  Future<void> createDatabaseTables(Database database) async {
    await database.execute('''
CREATE TABLE IF NOT EXISTS Collections (
    appId INTEGER PRIMARY KEY AUTOINCREMENT,
    id INTEGER,
    name TEXT,
    poster_path TEXT,
    backdrop_path TEXT
);
''');
    await database.execute('''
CREATE TABLE IF NOT EXISTS Companies (
    appId INTEGER PRIMARY KEY AUTOINCREMENT,
    id INTEGER,
    logo_path TEXT,
    name TEXT,
    origin_country TEXT
);
''');
    await database.execute('''
CREATE TABLE IF NOT EXISTS Genres (
    appId INTEGER PRIMARY KEY AUTOINCREMENT,
    id INTEGER,
    name TEXT
);
''');
    await database.execute('''
CREATE TABLE IF NOT EXISTS Movies (
    appId INTEGER PRIMARY KEY AUTOINCREMENT,
    id INTEGER,
    adult BOOLEAN,
    backdrop_path TEXT,
    budget INTEGER,
    homepage TEXT,
    imdb_id TEXT,
    origin_country TEXT,
    original_language TEXT,
    original_title TEXT,
    overview TEXT,
    popularity REAL,
    poster_path TEXT,
    production_countries TEXT,
    release_date TEXT,  -- Store as TEXT (ISO8601) for SQLite compatibility
    revenue INTEGER,
    runtime INTEGER,
    spoken_languages TEXT,
    status TEXT,
    tagline TEXT,
    title TEXT,
    video BOOLEAN,
    vote_average REAL,
    vote_count INTEGER,
    favorite BOOLEAN,
	  collectionId INTEGER,
    collectionAppId INTEGER,  -- Foreign Key for Collections
    FOREIGN KEY (collectionAppId) REFERENCES Collections(appId)
);
''');
    await database.execute('''
CREATE TABLE IF NOT EXISTS MovieGenres (
    movieAppId INTEGER,
    genreAppId INTEGER,
    PRIMARY KEY (movieAppId, genreAppId), -- Composite Primary Key
    FOREIGN KEY (movieAppId) REFERENCES Movies(appId),
    FOREIGN KEY (genreAppId) REFERENCES Genres(appId)
);
''');
    await database.execute('''
CREATE TABLE IF NOT EXISTS MovieCompanies (
    movieAppId INTEGER,
    companyAppId INTEGER,
    PRIMARY KEY (movieAppId, companyAppId), -- Composite Primary Key
    FOREIGN KEY (movieAppId) REFERENCES Movies(appId),
    FOREIGN KEY (companyAppId) REFERENCES Companies(appId)
);
''');
  }
}
