import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _dbName = "myDatabase.db";
  static final _dbVersion = 1;
  static final _tableName = "myTable";

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnPhone = 'number';
  static final columnAmount = 'amount';
  static final columnCondition = 'condition';
  static final columnDescription = 'description';
  static final columnIcon = 'icon';
  static final columnSettled = 'settled';

  //making it a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  //getting database
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initiateDatabase();
    return _database;
  }

  //initiate database
  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    print(path);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  //creating database at local storage
  Future _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE $_tableName(
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT ,
      $columnPhone TEXT,
      $columnAmount INTEGER,
      $columnCondition TEXT,
      $columnDescription TEXT,
      $columnIcon INTEGER,
      $columnSettled INTEGER DEFAULT 0
      )
      ''');
  }

  //insert data
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  //reading data
  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  //read data with specific customer Name (WORKS)
  Future<List<Map<String, dynamic>>> queryName(String name) async {
    Database db = await instance.database;
    var result = await db.rawQuery("SELECT * FROM $_tableName WHERE $columnName = '$name' ");
    return result;
  }

  //Settled Transaction
  Future<List<Map<String, dynamic>>> querySettled(String name) async {
    Database db = await instance.database;
    var result = await db.rawQuery("SELECT * FROM $_tableName WHERE $columnName = '$name' AND $columnSettled = 1");
    return result;
  }
  
  //Unsettled Transaction
  Future<List<Map<String, dynamic>>> queryUnSettled(String name) async {
    Database db = await instance.database;
    var result = await db.rawQuery("SELECT * FROM $_tableName WHERE $columnName = '$name' AND $columnSettled = 0");
    return result;
  }

  //List of all unique names (WORKS)
  Future<List<Map<String, dynamic>>> uniqueNames() async {
    Database db = await instance.database;
    var result = await db.rawQuery("SELECT DISTINCT $columnName FROM $_tableName");
    return result;
  }

  //Update data
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  //delete data
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> TotalToGive() async {
    Database db = await instance.database;
    var result = await db.rawQuery(
        "SELECT SUM($columnAmount) FROM $_tableName WHERE $columnCondition = 'Give' AND $columnSettled = 0");
    if (result[0]['SUM(amount)'] == null) {
      return 0;
    } else {
      return await result[0]['SUM(amount)'];
    }
  }

  Future<int> TotalToTake() async {
    Database db = await instance.database;
    var result = await db.rawQuery(
        "SELECT SUM($columnAmount) FROM $_tableName WHERE $columnCondition = 'Take' AND $columnSettled = 0");
    if (result[0]['SUM(amount)'] == null) {
      return 0;
    } else {
      return await result[0]['SUM(amount)'];
    }
  }

  //NAME SPECIFIC:
  Future<int> namedTotalToGive(String name) async {
    Database db = await instance.database;
    var result = await db.rawQuery(
        "SELECT SUM($columnAmount) FROM $_tableName WHERE $columnCondition = 'Give' AND $columnName = '$name' AND $columnSettled = 0");
    if (result[0]['SUM(amount)'] == null) {
      return 0;
    } else {
      return await result[0]['SUM(amount)'];
    }
  }

  Future<int> namedTotalToTake(String name) async {
    Database db = await instance.database;
    var result = await db.rawQuery(
        "SELECT SUM($columnAmount) FROM $_tableName WHERE $columnCondition = 'Take' AND $columnName = '$name' AND $columnSettled =0");
    if (result[0]['SUM(amount)'] == null) {
      return 0;
    } else {
      return await result[0]['SUM(amount)'];
    }
  }
}
