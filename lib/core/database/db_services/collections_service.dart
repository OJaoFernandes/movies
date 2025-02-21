import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/collection.dart';
import '../database_service.dart';

class CollectionsService {
  final String tableName = 'Collections';
  final getIt = GetIt.instance;

  Future<int?> create({required Collection collection}) async {
    final db = await getIt.get<DatabaseService>().database;

    final existing = await findById(collection.id!);
    if (existing != null) return null;

    return await db.insert(
      tableName,
      {
        'id': collection.id,
        'name': collection.name,
        'posterPath': collection.posterPath,
        'backdropPath': collection.backdropPath,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Collection>> findAll() async {
    final db = await getIt.get<DatabaseService>().database;
    final results = await db.query(tableName);
    return results.map((map) => Collection.fromJson(map)).toList();
  }

  Future<Collection?> findById(int id) async {
    final db = await getIt.get<DatabaseService>().database;
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return Collection.fromJson(results.first);
  }

  Future<Collection?> findByAppId(int appId) async {
    final db = await getIt.get<DatabaseService>().database;
    final results = await db.query(
      tableName,
      where: 'appId = ?',
      whereArgs: [appId],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return Collection.fromJson(results.first);
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
