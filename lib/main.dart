import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:flutter_onjung_v1/core/config/app_theme.dart';
import 'package:flutter_onjung_v1/core/services/database_mobile.dart'; // MobileDatabaseHelper 추가
import 'package:flutter_onjung_v1/core/services/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Flutter 엔진 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 데이터베이스 강제 삭제 (개발용)
  final bool forceRecreateDatabase = true; // 개발 단계에서만 true로 설정
  if (forceRecreateDatabase) {
    try {
      debugPrint('기존 데이터베이스 삭제 시작');
      await DatabaseProvider.instance.deleteDatabase(); // 데이터베이스 삭제
      debugPrint('기존 데이터베이스 삭제 완료');
    } catch (e, stackTrace) {
      debugPrint('데이터베이스 삭제 실패: $e');
      debugPrint('스택트레이스: $stackTrace');
    }
  }

  // MobileDatabaseHelper 초기화 호출
  try {
    debugPrint('MobileDatabaseHelper 초기화 시작');
    await MobileDatabaseHelper().initialize(); // 데이터베이스 초기화
    debugPrint('MobileDatabaseHelper 초기화 성공');
  } catch (e, stackTrace) {
    debugPrint('MobileDatabaseHelper 초기화 실패: $e');
    debugPrint('스택트레이스: $stackTrace');
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
