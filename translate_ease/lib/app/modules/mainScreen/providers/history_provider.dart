import 'package:get/get.dart';

import '../history_model.dart';

import 'package:sqflite/sqflite.dart';
import 'package:translate_ease/app/data/DatabaseService.dart';

class HistoryProvider extends GetConnect {
  final tableName = 'history';
  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        message TEXT,
        message_language TEXT,
        translation_language TEXT,
        translation TEXT,
        isFavorite INTEGER,
        side TEXT,
        createdAt TEXT
      )
    ''');
  }

  Future<int> insert({
    required String text,
    required String to_lang,
    required String from_lang,
    required String translated_text,
    required int isFavorite,
    required String side,
    required String createdAt,
  }) async {
    Database db = await DatabaseService().database;

    return await db.insert(tableName, {
      'message': text,
      'message_language': to_lang,
      'translation_language': from_lang,
      'translation': translated_text,
      'side': side,
      'isFavorite': isFavorite,
      'createdAt': createdAt
    });
  }

  Future<List<History>> getAll() async {
    Database db = await DatabaseService().database;
    final List<Map<String, dynamic>> history = await db.rawQuery(
      'SELECT * FROM $tableName  ORDER BY id DESC',
    );
    return history.map((h) => History.fromSqfliteDatabase(h)).toList();
  }

  Future<int> deleteData(int id) async {
    Database db = await DatabaseService().database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

   Future<int> deleteAll() async {
    Database db = await DatabaseService().database;
    return await db.delete(tableName);
  }
  Future<List<History>> getFavorite() async {
    Database db = await DatabaseService().database;

    final List<Map<String, dynamic>> history = await db.rawQuery(
      'SELECT * FROM $tableName WHERE isFavorite = 1  ORDER BY id DESC',
    );
    return history.map((h) => History.fromSqfliteDatabase(h)).toList();
  }

  //search

  Future<List<History>> search(String text) async {
    Database db = await DatabaseService().database;
    final List<Map<String, dynamic>> history = await db.rawQuery(
      'SELECT * FROM $tableName WHERE message LIKE ? ORDER BY id DESC',
      ['%$text%'],
    );
    return history.map((h) => History.fromSqfliteDatabase(h)).toList();
  }

  //dateFilter

  Future<List<History>> dateFilter(String date) async {
    Database db = await DatabaseService().database;
    final List<Map<String, dynamic>> history = await db.rawQuery(
      'SELECT * FROM $tableName WHERE createdAt LIKE ? ORDER BY id DESC',
      ['%$date%'],
    );
    return history.map((h) => History.fromSqfliteDatabase(h)).toList();
  }
  
  Future<int> isFavorite(int id , int isFavorite) async {
    Database db = await DatabaseService().database;
    return await db.rawUpdate(
        'UPDATE $tableName SET isFavorite = ? WHERE id = ?', [isFavorite, id]);
  }
}
