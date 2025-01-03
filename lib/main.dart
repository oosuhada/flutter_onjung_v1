import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/app_router.dart';
import 'package:flutter_onjung_v1/core/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Flutter 엔진 초기화
  WidgetsFlutterBinding.ensureInitialized();

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
