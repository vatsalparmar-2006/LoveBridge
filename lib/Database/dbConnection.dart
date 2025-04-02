import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/constant.dart';

class DbConnection {
  static final DbConnection _instance = DbConnection._internal();
  static Database? _database;

  factory DbConnection() {
    return _instance;
  }

  DbConnection._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'Love_Bridge.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User_Table(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        $NAME TEXT,
        $EMAIL TEXT,
        $PHONE TEXT,
        $DOB TEXT,
        $ADDRESS TEXT,
        $CASTE TEXT,
        $OCCUPATION TEXT,
        $CITY TEXT,
        $GENDER TEXT,
        $HOBBY TEXT,
        $AGE INTEGER,
        $COUNTRY TEXT,
        $COMPLEXION TEXT,
        $HEIGHT TEXT,
        $RELIGION TEXT,
        $RASHI TEXT,
        $MOTHER_TONGUE TEXT,
        $NAKSHATRA TEXT,
        $EDUCATION TEXT,
        $ANNUAL_INCOME TEXT,
        $NICK_NAME TEXT,
        is_favorite INTEGER DEFAULT 0
      )
    ''');
  }

  Future<bool> insertProfile(Map<String, dynamic> profile) async{
    var db = await database;
    int rowsEffectd= await db.insert("User_Table", profile);
    return rowsEffectd>0;
  }

  Future<List<Map<String, dynamic>>> getProfiles() async {
    final db = await database;
    return await db.query('User_Table');
  }


  Future<int> updateProfiles(Map<String, dynamic> profile) async {
    Database db = await database;
    return await db.update('User_Table', profile, where: 'id = ?', whereArgs: [profile['id']]);
  }

  Future<int> deleteProfiles(int id) async {
    Database db = await database;
    return await db.delete('User_Table', where: 'id = ?', whereArgs: [id]);
  }
}