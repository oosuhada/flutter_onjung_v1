import 'package:firebase_core/firebase_core.dart'; // Firebase 초기화를 위해 import 추가
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:flutter_onjung_v1/core/config/app_settings_manager.dart';
import 'package:flutter_onjung_v1/core/config/app_theme.dart';
import 'package:flutter_onjung_v1/core/database_services/database_mobile.dart'; // MobileDatabaseHelper 추가
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Flutter 엔진 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  try {
    debugPrint('Firebase 초기화 시작');
    await Firebase.initializeApp(); // Firebase 초기화 호출
    debugPrint('Firebase 초기화 성공');
  } catch (e, stackTrace) {
    debugPrint('Firebase 초기화 실패: $e');
    debugPrint('스택트레이스: $stackTrace');
  }

  // MobileDatabaseHelper 초기화 호출
  try {
    debugPrint('MobileDatabaseHelper 초기화 시작');
    await MobileDatabaseHelper().initialize();
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
    final appSettings = ref.watch(appSettingsProvider);
    return MaterialApp.router(
      title: '온정',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme1(),
      darkTheme: AppTheme.darkTheme1(),
      themeMode: appSettings.themeMode, // useSystemTheme 제거, themeMode 사용
      routerConfig: goRouter,
    );
  }
}
