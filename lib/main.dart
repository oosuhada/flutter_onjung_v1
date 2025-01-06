import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:flutter_onjung_v1/core/config/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  // async 추가
  // Flutter 엔진 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // SQLite 초기화
  try {
    final databasesPath = await getDatabasesPath();
    debugPrint('SQLite 초기화 - 데이터베이스 경로: $databasesPath');

    // 데이터베이스 경로 확인
    final path = join(databasesPath, 'gift_records.db');
    debugPrint('데이터베이스 파일 경로: $path');
  } catch (e) {
    debugPrint('SQLite 초기화 중 오류 발생: $e');
  }

  // ProviderScope로 앱을 감싸서 Riverpod 사용 가능하게 함
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: '온정',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      routerConfig: goRouter, // app_router.dart에서 정의한 라우터 설정 사용
    );
  }
}
