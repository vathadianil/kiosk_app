import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelperController extends GetxController {
  static DatabaseHelperController get instance => Get.find();
  static Database? _database;
  final tableName = 'ticket_info';

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initDB();
  }

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    try {
      if (kDebugMode) {
        print('Database Initialization started');
      }
      String path = join(await getDatabasesPath(), 'my_database.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await _createTables(db, tableName);
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Database Initialization Failed: $e');
      }
      rethrow;
    }
  }

  static Future<void> _createTables(Database db, String tableName) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      purchaseId TEXT,
      ticketId TEXT UNIQUE,
      ticketContent TEXT,
      fromStationId TEXT,
      toStationId TEXT,
      ticketTypeId INTEGER,
      ticketStatus TEXT,
      entryExitType TEXT,
      platFormNo TEXT,
      ticketExpiryTime TEXT,
      carbonEmissionMsg TEXT,
      orderId TEXT
      )
    ''');
  }

  Future<int> insertData(String tableName, Map<String, dynamic> payload) async {
    try {
      final db = await database;

      return await db.insert(
        tableName,
        payload,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting data into $tableName: $e');
      }
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getAllData(String tableName) async {
    try {
      final db = await database;
      return await db.query(tableName);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data from $tableName: $e');
      }
      return [];
    }
  }

  Future<int> updateDataById(
      int id, String tableName, Map<String, Object?> payload) async {
    try {
      final db = await database;
      return await db.update(
        tableName,
        payload,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error updating data in $tableName: $e');
      }
      return -1;
    }
  }

  Future<int> deleteDataById(int id, String tableName) async {
    try {
      final db = await database;
      return await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting data from $tableName: $e');
      }
      return -1;
    }
  }

  Future<void> dropTableAndCreateNewOne(String tableName) async {
    try {
      final db = await database;
      await db.execute('DROP TABLE IF EXISTS $tableName');
      await _createTables(db, tableName);
    } catch (e) {
      if (kDebugMode) {
        print('Error dropping and recreating table $tableName: $e');
      }
    }
  }
}
