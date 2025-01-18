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
    debugPrint('테이블 생성 시작');
    try {
      await db.execute('''
    CREATE TABLE gift_records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount INTEGER NOT NULL,
        isSent INTEGER NOT NULL,
        date TEXT NOT NULL,
        method TEXT,
        receiverName TEXT,
        eventType TEXT,
        didVisit INTEGER,
        gift TEXT,
        memo TEXT,
        contact TEXT
    )
    ''');
      debugPrint('테이블 생성 완료');
    } catch (e, stackTrace) {
      debugPrint('테이블 생성 실패: $e');
      debugPrint('스택트레이스: $stackTrace');
      rethrow;
    }
  }

  //   Future<void> _createDB(Database db, int version) async {
  //   await db.execute('''
  // CREATE TABLE gift_records(
  //   id INTEGER PRIMARY KEY AUTOINCREMENT,
  //   amount INTEGER NOT NULL,           // 금액 (필수)
  //   isSent INTEGER NOT NULL,          // 보내기/받기 구분 (필수)
  //   date TEXT NOT NULL,               // 날짜 (필수)
  //   method TEXT,                      // 지불 방법 (선택)
  //   receiverName TEXT,                // 받는 사람 (선택)
  //   eventType TEXT,                   // 이벤트 종류 (선택)
  //   didVisit INTEGER,                 // 방문 여부 (선택)
  //   gift TEXT,                        // 선물 정보 (선택)
  //   memo TEXT,                        // 메모 (선택)
  //   contact TEXT                      // 연락처 (선택)
  // )
  // ''');
  // }

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
