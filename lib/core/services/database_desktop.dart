// database_desktop.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'database_interface.dart';

class DesktopDatabaseHelper implements DatabaseInterface {
  static Database? _database;

  @override
  Future<void> initialize() async {
    if (_database != null) return;

    sqfliteFfiInit();

    final dbPath = Directory.current.path;
    final dbDir = Directory(join(dbPath, 'databases'));
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }
    final path = join(dbDir.path, 'gift_records.db');
    debugPrint('데이터베이스 경로 (데스크톱): $path');

    _database = await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _createDB,
      ),
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE gift_records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount INTEGER NOT NULL,
        receiverName TEXT NOT NULL,
        isSent INTEGER NOT NULL,
        eventType TEXT NOT NULL,
        date TEXT NOT NULL,
        didVisit INTEGER,
        gift TEXT,
        memo TEXT,
        contact TEXT
      )
    ''');
  }

  @override
  Future<int> insertRecord(Map<String, dynamic> record) async {
    final db = _database;
    if (db == null) throw Exception('Database not initialized');
    return await db.insert('gift_records', record);
  }

  @override
  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
