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
      CREATE TABLE transactions(
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        title TEXT NOT NULL,
        amount INTEGER NOT NULL,
        method TEXT NOT NULL,
        counterpart TEXT,
        relation TEXT,
        relationDetail TEXT,
        memberInfo TEXT, 
        scheduleInfo TEXT,
        activityInfo TEXT
      )
    ''');
      debugPrint('테이블 생성 완료');
    } catch (e, stackTrace) {
      debugPrint('테이블 생성 실패: $e');
      debugPrint('스택트레이스: $stackTrace');
      rethrow;
    }
  }

// Future<void> _createDB(Database db, int version) async {
//   debugPrint('테이블 생성 시작');
//   try {
//     await db.execute('''
//       CREATE TABLE transactions(
//         id TEXT PRIMARY KEY,
//         type TEXT NOT NULL, -- 'sent' 또는 'received'
//         date TEXT NOT NULL,
//         title TEXT NOT NULL,
//         amount INTEGER NOT NULL,
//         method TEXT NOT NULL, -- 결제 방법
//         counterpart TEXT, -- 거래 상대 이름
//         relation TEXT, -- 거래 상대와의 관계
//         relationDetail TEXT, -- 관계 상세 설명
//         memberInfo TEXT, -- 관련된 멤버 정보 (JSON 문자열)
//         scheduleInfo TEXT, -- 관련된 스케줄 정보 (JSON 문자열)
//         activityInfo TEXT -- 관련된 활동 정보 (JSON 문자열)
//       )
//     ''');
//     debugPrint('테이블 생성 완료');
//   } catch (e, stackTrace) {
//     debugPrint('테이블 생성 실패: $e');
//     debugPrint('스택트레이스: $stackTrace');
//     rethrow;
//   }
// }

  @override
  Future<int> insertRecord(Map<String, dynamic> record) async {
    final db = _database;
    await db?.insert('transactions', record); // 'transactions'은 테이블 이름
    if (db == null) throw Exception('Database not initialized');
    return await db.insert('gift_records', record);
  }

  @override
  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
