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
  //     CREATE TABLE gift_records(
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
    if (db == null) {
      throw Exception('Database not initialized'); // 초기화되지 않은 경우 예외 발생
    }

    try {
      debugPrint('저장할 데이터: $record');
      final id = await db.insert('transactions', record); // transactions 테이블 사용
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
