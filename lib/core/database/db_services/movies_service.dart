import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/collection.dart';
import '../../../models/company.dart';
import '../../../models/genre.dart';
import '../../../models/movie.dart';
import '../database_service.dart';
import 'collections_service.dart';
import 'companies_service.dart';
import 'genres_service.dart';

class MoviesService {
  final String tableName = 'Movies';
  final String alias = 'm';
  final getIt = GetIt.instance;

  Future<Movie> create(Movie movie) async {
    final db = await getIt.get<DatabaseService>().database;

    final movieExists = await db.query(tableName, where: 'id = ?', whereArgs: [movie.id], limit: 1);
    if (movieExists.isNotEmpty) {
      return Movie.fromJson(movieExists.first);
    }

    if (movie.collection != null) {
      await getIt.get<CollectionsService>().create(collection: movie.collection!);
    }

    final movieAppId = await db.insert(
      tableName,
      {
        'id': movie.id,
        'adult': (movie.adult == true ? 1 : 0),
        'backdrop_path': movie.backdropPath,
        'budget': movie.budget,
        'homepage': movie.homepage,
        'imdb_id': movie.imdbId,
        'origin_country': jsonEncode(movie.originCountry),
        'original_language': movie.originalLanguage,
        'original_title': movie.originalTitle,
        'overview': movie.overview,
        'popularity': movie.popularity,
        'poster_path': movie.posterPath,
        'production_countries': jsonEncode(movie.productionCountries),
        'release_date': movie.releaseDate?.toIso8601String() ?? '',
        'revenue': movie.revenue,
        'runtime': movie.runtime,
        'spoken_languages': jsonEncode(movie.spokenLanguages),
        'status': movie.status,
        'tagline': movie.tagline,
        'title': movie.title,
        'video': (movie.video == true ? 1 : 0),
        'vote_average': movie.voteAverage,
        'vote_count': movie.voteCount,
        'favorite': (movie.favorite == true ? 1 : 0),
        'collectionId': movie.collection?.id ?? 0,
        'collectionAppId': movie.collection?.appId ?? 0,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    if (movieAppId == 0) {
      throw Exception('Error inserting movie into $tableName');
    }

    if (movie.genres != null) {
      await getIt.get<GenresService>().createAll(
        movieAppId: movieAppId,
        genres: movie.genres!,
      );
    }
    if (movie.productionCompanies != null) {
      await getIt.get<CompaniesService>().createAll(
        movieAppId: movieAppId,
        companies: movie.productionCompanies!,
      );
    }

    return findByAppId(movieAppId);
  }

  Future<List<Movie>> findAll({String? name}) async {
    final db = await getIt.get<DatabaseService>().database;
    String query = 'SELECT * FROM $tableName';
    List<Object?> args = [];

    if (name != null && name.isNotEmpty) {
      query += ' WHERE title LIKE ?';
      args.add('%$name%');
    }

    final rawMovies = await db.rawQuery(query, args);

    return _mapMovies(rawMovies);
  }

  Future<Movie> findById(int id) async {
    final db = await getIt.get<DatabaseService>().database;
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) {
      throw Exception('No movie found with id=$id');
    }
    return _mapMovies([results.first]).first;
  }

  Future<Movie> findByAppId(int appId) async {
    final db = await getIt.get<DatabaseService>().database;
    final results = await db.query(
      tableName,
      where: 'appId = ?',
      whereArgs: [appId],
      limit: 1,
    );
    if (results.isEmpty) {
      throw Exception('No movie found with appId=$appId');
    }
    return _mapMovies([results.first]).first;
  }

  Future<List<Movie>> findByGenre({required Genre genre}) async {
    final db = await getIt.get<DatabaseService>().database;
    final query = '''
SELECT $alias.* 
FROM $tableName $alias
JOIN MovieGenres mg ON $alias.id = mg.movieAppId
WHERE mg.genreAppId = ?
''';

    final rawMovies = await db.rawQuery(query, [genre.id]);
    return _mapMovies(rawMovies);
  }

  Future<List<Movie>> findByCollection({required Collection collection}) async {
    final db = await getIt.get<DatabaseService>().database;

    final results = await db.query(
      tableName,
      where: 'collectionId = ?',
      whereArgs: [collection.id],
    );
    for (final row in results) {
      row['collection'] = collection.toJson();
    }
    return _mapMovies(results);
  }

  Future<List<Movie>> findByCompany({required Company company}) async {
    final db = await getIt.get<DatabaseService>().database;
    final query = '''
SELECT $alias.* 
FROM $tableName $alias
JOIN MovieCompanies mc ON $alias.id = mc.movieAppId
WHERE mc.companyAppId = ?
''';
    final rawMovies = await db.rawQuery(query, [company.id]);
    return _mapMovies(rawMovies);
  }

  Future<List<int>> findFavoriteIds() async {
    final db = await getIt.get<DatabaseService>().database;
    final results = await db.query(
      tableName,
      columns: ['id'],
      where: 'favorite = 1',
    );
    return results.map((row) => row['id'] as int).toList();
  }

  Future<Movie> delete(Movie movie) async {
    final db = await getIt.get<DatabaseService>().database;
    final count = await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
    if (count == 0) {
      throw Exception('Error deleting movie with id=${movie.id}');
    }
    return movie;
  }

  Future<List<Movie>> deleteAll() async {
    final db = await getIt.get<DatabaseService>().database;
    final oldMovies = await db.query(tableName);
    final count = await db.delete(tableName);
    if (count == 0) {
      return [];
    }
    return oldMovies.map((row) => Movie.fromJson(row)).toList();
  }

  List<Movie> _mapMovies(List<Map<String, Object?>> rawRows) {
    final List<Map<String, Object?>> clonedRows =
        rawRows.map((row) => Map<String, Object?>.from(row)).toList();

    for (final row in clonedRows) {
      row['adult'] = (row['adult'] == 1);
      row['video'] = (row['video'] == 1);
      row['favorite'] = (row['favorite'] == 1);

      if (row['origin_country'] != null) {
        row['origin_country'] = _parseStringList(row['origin_country']);
      }
      if (row['production_countries'] != null) {
        row['production_countries'] =
            jsonDecode(row['production_countries'] as String)
                as List<dynamic>?;
      }
      if (row['spoken_languages'] != null) {
        row['spoken_languages'] =
            jsonDecode(row['spoken_languages'] as String) as List<dynamic>?;
      }

    }

    return clonedRows.map((row) => Movie.fromJson(row)).toList();
  }

  List<String>? _parseStringList(Object? data) {
    if (data == null) return null;
    if (data is String) {
      try {
        final List<dynamic> decoded = jsonDecode(data);
        return decoded.map((e) => e.toString()).toList();
      } catch (_) {
      }
    }
    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }
    return null;
  }
}
