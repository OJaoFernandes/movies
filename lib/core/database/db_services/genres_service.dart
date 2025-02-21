import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/genre.dart';
import '../database_service.dart';

class GenresService {
  final String tableName = 'Genres';
  final getIt = GetIt.instance;

  Future<int?> create({required Genre genre}) async {
    final db = await getIt.get<DatabaseService>().database;
    final existing = await findById(genre.id!);
    if (existing != null) return null;

    return db.insert(
      tableName,
      {
        'id': genre.id,
        'name': genre.name,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<int>> createAll({
    required int movieAppId,
    required List<Genre> genres,
  }) async {
    final db = await getIt.get<DatabaseService>().database;
    final List<int> insertedIds = [];

    for (final genre in genres) {
      final existing = await findById(genre.id!);
      if (existing == null) {
        final newId = await db.insert(
          tableName,
          {'id': genre.id, 'name': genre.name},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        insertedIds.add(newId);
      }
      await db.insert(
        'MovieGenres',
        {
          'movieAppId': movieAppId,
          'genreAppId': genre.id,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    return insertedIds;
  }

  Future<List<Genre>> findAll() async {
    final db = await getIt.get<DatabaseService>().database;
    final results = await db.query(tableName);
    return results.map((map) => Genre.fromJson(map)).toList();
  }

  Future<Genre?> findById(int id) async {
    final db = await getIt.get<DatabaseService>().database;
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return Genre.fromJson(results.first);
  }

  Future<Genre?> findByAppId(int appId) async {
    final db = await getIt.get<DatabaseService>().database;
    final results = await db.query(
      tableName,
      where: 'appId = ?',
      whereArgs: [appId],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return Genre.fromJson(results.first);
  }

  Future<List<Genre?>> findByMovieAppId(int movieAppId) async {
    final db = await getIt.get<DatabaseService>().database;
    final query = '''
SELECT $tableName.* 
FROM $tableName
JOIN MovieGenres mg ON $tableName.id = mg.genreAppId
WHERE mg.movieAppId = ?
''';
    final results = await db.rawQuery(query, [movieAppId]);
    return results.map((map) => Genre.fromJson(map)).toList();
  }

  Future<int> delete(int appId) async {
    final db = await getIt.get<DatabaseService>().database;
    return db.delete(
      tableName,
      where: 'appId = ?',
      whereArgs: [appId],
    );
  }
}
