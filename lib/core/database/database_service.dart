import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'movies_db.dart';

class DatabaseService {
  Database? _database;
  String name = 'movies.db';
  int version = 1;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<Database> _initialize() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, name);

    var database = await openDatabase(
      path,
      version: version,
      onCreate: (db, version) => MoviesDB().createDatabaseTables(db),
      singleInstance: true,
    );
    return database;
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> delete() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, name);
    await deleteDatabase(path);
    _database = null;
  }
}
