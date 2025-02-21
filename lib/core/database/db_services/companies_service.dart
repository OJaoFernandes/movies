import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/company.dart';
import '../database_service.dart';

class CompaniesService {
  final String tableName = 'Companies';
  final getIt = GetIt.instance;

  Future<int?> create({required Company company}) async {
    final db = await getIt.get<DatabaseService>().database;
    final existing = await findById(company.id!);
    if (existing != null) return null;

    return await db.insert(
      tableName,
      {
        'id': company.id,
        'name': company.name,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<int>> createAll({
    required int movieAppId,
    required List<Company> companies,
  }) async {
    final db = await getIt.get<DatabaseService>().database;
    final List<int> insertedIds = [];

    for (final company in companies) {
      final existing = await findById(company.id!);
      if (existing == null) {
        final newId = await db.insert(
          tableName,
          {
            'id': company.id,
            'name': company.name,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        insertedIds.add(newId);
      }
      await db.insert(
        'MovieCompanies',
        {
          'movieAppId': movieAppId,
          'companyAppId': company.id,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    return insertedIds;
  }

  Future<List<Company>> findAll() async {
    final db = await getIt.get<DatabaseService>().database;
    final results = await db.query(tableName);
    return results.map((map) => Company.fromJson(map)).toList();
  }

  Future<Company?> findById(int id) async {
    final db = await getIt.get<DatabaseService>().database;
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return Company.fromJson(results.first);
  }

  Future<Company?> findByAppId(int appId) async {
    final db = await getIt.get<DatabaseService>().database;
    final results = await db.query(
      tableName,
      where: 'appId = ?',
      whereArgs: [appId],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return Company.fromJson(results.first);
  }

  Future<List<Company?>> findByMovieAppId(int movieAppId) async {
    final db = await getIt.get<DatabaseService>().database;

    final query = '''
SELECT $tableName.* 
FROM $tableName
JOIN MovieCompanies mc ON $tableName.id = mc.companyAppId
WHERE mc.movieAppId = ?
''';

    final results = await db.rawQuery(query, [movieAppId]);
    return results.map((row) => Company.fromJson(row)).toList();
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
