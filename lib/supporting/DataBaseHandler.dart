import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DataBaseHandler {
  static final _dbName = 'savings.db';
  static final _dbVersion = 1;
  static final _tableName = 'savingsTable';
  static final id = 'id';
  static final tileColor = 'color';
  static final title = 'title';
  static final info = 'info';
  static final history = 'history';
  static final saved = 'cSaved';
  static final goal = 'goal';

  DataBaseHandler._privateConstructor();
  static final DataBaseHandler instance = DataBaseHandler._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDataBase();
    return _database;
  }

  _initDataBase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    db.execute('''CREATE TABLE $_tableName( 
        $id INTEGER PRIMARY KEY,
        $title TEXT NOT NULL,
        $tileColor INTEGER NOT NULL,
        $saved REAL,
        $goal REAL,
        $info TEXT,
        $history TEXT ) ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return db.query(_tableName);
  }

  Future update(Map<String, dynamic> row, int idPassed) async {
    Database db = await instance.database;
    return db.update(_tableName, row, where: '$id = ?', whereArgs: [idPassed]);
  }

  Future delete(int idPassed) async {
    Database db = await instance.database;
    return db.delete(_tableName, where: '$id = ?', whereArgs: [idPassed]);
  }
}
