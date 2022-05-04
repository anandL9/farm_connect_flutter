import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _myDatabaseName = 'FarmConnect.db';
  static const _dataBaseVersion = 1;

  static const table = 'products';

  static const columnId = '_id';
  static const columnProductId = 'productId';
  static const columnProductName = 'productName';
  static const columnClosingStock = 'closingStock';
  static const columnOrder = 'stockOrder';
  static const columnReturns = 'stockReturns';
  static const columnComments = 'comments';
  static const columnImage1 = 'image1';
  static const columnImage2 = 'image2';
  static const columnImage3 = 'image3';
  static const columnImage4 = 'image4';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static late Database _database;

  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _myDatabaseName);
    return await openDatabase(path,
        version: _dataBaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(''' CREATE TABLE $table (
                      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
                      $columnProductId TEXT,
                      $columnProductName TEXT,
                      $columnClosingStock TEXT,
                      $columnOrder TEXT,
                      $columnReturns TEXT,
                      $columnComments TEXT,
                      $columnImage1 TEXT,
                      $columnImage2 TEXT,
                      $columnImage3 TEXT,
                      $columnImage4 TEXT
                      )
                      ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete() async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}
