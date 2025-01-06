// database_provider.dart
import 'package:flutter/foundation.dart';

import 'database_factory.dart';
import 'database_interface.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();
  static DatabaseInterface? _database;

  DatabaseProvider._init();

  Future<DatabaseInterface> get database async {
    if (_database != null) return _database!;

    debugPrint('데이터베이스 초기화 시작');
    _database = DatabaseFactory.create();
    await _database!.initialize();
    debugPrint('데이터베이스 초기화 완료');
    return _database!;
  }
}
