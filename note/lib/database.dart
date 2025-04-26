import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'note_model.dart';

class DatabaseHelper {
  static Database? _db;
  static const String tableName = "notes";

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await create();
    return _db!;
  }

  Future<Database> create() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "notes.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            body TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> addNote({required Note note}) async {
    final dbClient = await db;
    return await dbClient.insert(tableName, note.toMap());
  }

  Future<List<Note>> getAllNotes() async {
    final dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query(tableName);
    return result.map((e) => Note.fromMap(e)).toList();
  }

  Future<int> deleteNote({required Note note}) async {
    final dbClient = await db;
    return await dbClient.delete(tableName, where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> updateNote({required Note note}) async {
    final dbClient = await db;
    return await dbClient.update(
      tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteAllNotes() async {
    final dbClient = await db;
    return await dbClient.delete(tableName);
  }
}