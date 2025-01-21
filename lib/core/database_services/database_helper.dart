// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// // FFI는 데스크톱 플랫폼용으로만 import
// import 'package:sqflite_common_ffi/sqflite_ffi.dart' if (dart.library.html) 'package:sqflite_common_ffi/sqflite_ffi.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;

//   DatabaseHelper._init() {
//     _initPlatformSpecific();
//   }

//   void _initPlatformSpecific() {
//     // FFI 초기화는 데스크톱 플랫폼에서만 실행
//     if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
//       sqfliteFfiInit();
//       databaseFactory = databaseFactoryFfi;
//     }
//   }

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     debugPrint('데이터베이스 초기화 시작');
//     _database = await _initDB('gift_records.db');
//     debugPrint('데이터베이스 초기화 완료');
//     return _database!;
//   }

//   Future<Database> _initDB(String fileName) async {
//     String path;

//     if (kIsWeb) {
//       throw UnsupportedError("Web platform is not supported.");
//     } else if (Platform.isAndroid || Platform.isIOS) {
//       // 모바일 플랫폼용 경로
//       final dbPath = await getDatabasesPath();
//       path = join(dbPath, fileName);
//       debugPrint('데이터베이스 경로 (모바일): $path');
//     } else {
//       // 데스크톱 플랫폼용 경로
//       final dbPath = Directory.current.path;
//       final dbDir = Directory(join(dbPath, 'databases'));
//       if (!await dbDir.exists()) {
//         await dbDir.create(recursive: true);
//       }
//       path = join(dbDir.path, fileName);
//       debugPrint('데이터베이스 경로 (데스크톱): $path');
//     }

//     try {
//       final db = await openDatabase(
//         path,
//         version: 1,
//         onCreate: _createDB,
//       );
//       return db;
//     } catch (e, stacktrace) {
//       debugPrint('데이터베이스 열기 실패: $e');
//       debugPrint('스택트레이스: $stacktrace');
//       rethrow;
//     }
//   }

//   Future<void> _createDB(Database db, int version) async {
//     debugPrint('테이블 생성 시작');
//     try {
//       await db.execute('''
//         CREATE TABLE gift_records(
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           amount INTEGER NOT NULL,
//           receiverName TEXT NOT NULL,
//           isSent INTEGER NOT NULL,
//           eventType TEXT NOT NULL,
//           date TEXT NOT NULL,
//           didVisit INTEGER,
//           gift TEXT,
//           memo TEXT,
//           contact TEXT
//         )
//       ''');
//       debugPrint('테이블 생성 완료');
//     } catch (e, stacktrace) {
//       debugPrint('테이블 생성 실패: $e');
//       debugPrint('스택트레이스: $stacktrace');
//       rethrow;
//     }
//   }

//   Future<int> insertGiftRecord(Map<String, dynamic> record) async {
//     debugPrint('저장할 데이터: $record');
//     final db = await instance.database;
//     try {
//       final result = await db.insert('gift_records', record);
//       debugPrint('데이터 저장 성공: ID=$result');
//       return result;
//     } catch (e, stacktrace) {
//       debugPrint('데이터 저장 실패: $e');
//       debugPrint('스택트레이스: $stacktrace');
//       rethrow;
//     }
//   }
// }
