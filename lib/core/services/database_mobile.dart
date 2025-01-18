// database_mobile.dart
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_interface.dart';

class MobileDatabaseHelper implements DatabaseInterface {
  static Database? _database;

  @override
  Future<void> initialize() async {
    try {
      debugPrint('모바일 데이터베이스 초기화 시작');

      if (_database != null) {
        debugPrint('데이터베이스가 이미 초기화되어 있음');
        return;
      }

      // 데이터베이스 경로 설정
      final databasesPath = await getDatabasesPath();
      debugPrint('데이터베이스 기본 경로: $databasesPath');

      final path = join(databasesPath, 'gift_records.db');
      debugPrint('최종 데이터베이스 경로: $path');

      // 데이터베이스 열기
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
        onOpen: (db) {
          debugPrint('데이터베이스 열기 성공');
        },
      );

      debugPrint('모바일 데이터베이스 초기화 완료');
    } catch (e, stackTrace) {
      debugPrint('데이터베이스 초기화 실패: $e');
      debugPrint('스택트레이스: $stackTrace');
      rethrow;
    }
  }

  Future<void> _createDB(Database db, int version) async {
    debugPrint('테이블 생성 시작');
    try {
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
      debugPrint('테이블 생성 완료');
    } catch (e, stackTrace) {
      debugPrint('테이블 생성 실패: $e');
      debugPrint('스택트레이스: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<int> insertRecord(Map<String, dynamic> record) async {
    debugPrint('레코드 삽입 시작');
    final db = _database;
    if (db == null) {
      throw Exception('Database not initialized');
    }

    try {
      debugPrint('저장할 데이터: $record');
      final id = await db.insert('gift_records', record);
      debugPrint('데이터 저장 성공: ID=$id');
      return id;
    } catch (e, stackTrace) {
      debugPrint('데이터 저장 실패: $e');
      debugPrint('스택트레이스: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    try {
      await _database?.close();
      _database = null;
      debugPrint('데이터베이스 닫기 성공');
    } catch (e, stackTrace) {
      debugPrint('데이터베이스 닫기 실패: $e');
      debugPrint('스택트레이스: $stackTrace');
      rethrow;
    }
  }
}
