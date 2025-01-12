// database_provider.dart
import 'package:flutter/foundation.dart';
import 'package:path/path.dart'; // 데이터베이스 경로를 다루기 위한 패키지
import 'package:sqflite/sqflite.dart' as sqflite; // sqflite 데이터베이스 작업을 위해 추가

import 'database_factory.dart';
import 'database_interface.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();
  static DatabaseInterface? _database;

  DatabaseProvider._init();

  // 데이터베이스 인스턴스를 얻는 메서드
  Future<DatabaseInterface> get database async {
    if (_database != null) return _database!;

    debugPrint('데이터베이스 초기화 시작');
    _database = DatabaseFactory.create();
    await _database!.initialize();
    debugPrint('데이터베이스 초기화 완료');
    return _database!;
  }

  // 데이터베이스 삭제 메서드 추가
  Future<void> deleteDatabase() async {
    try {
      final dbPath = await sqflite.getDatabasesPath(); // 데이터베이스 경로 가져오기
      final path = join(dbPath, 'gift_records.db'); // 특정 데이터베이스 파일 경로 생성

      // 데이터베이스 삭제
      await sqflite.deleteDatabase(path); // sqflite prefix 사용
      _database = null; // 데이터베이스 인스턴스를 초기화

      debugPrint('Database deleted successfully');
    } catch (e) {
      debugPrint('Error deleting database: $e'); // 삭제 실패 시 에러 출력
    }
  }
}
