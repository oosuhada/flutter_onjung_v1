// lib/features/splash/screens/loading_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    debugPrint('Initialization started');
    await Future.delayed(const Duration(seconds: 2)); // 2초 대기
    if (!mounted) return;

    debugPrint('Initialization completed');
    setState(() {
      _isLoading = false; // 로딩 상태 종료
    });

    context.goNamed(AppRoute.authOnboarding.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 245),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 200),
            Image.asset(
              'assets/logo/onjung_logo_clear_dark.png', // 로고 이미지 경로
              width: 200,
              height: 100,
            ),
            Text(
              '소중한 마음을 간직하는',
              style: TextStyle(
                fontSize: 21,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '가장 스마트한 방법',
              style: TextStyle(
                fontSize: 21,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 48),
            if (_isLoading)
              const CircularProgressIndicator(color: Colors.orange), // 로딩 인디케이터
            const SizedBox(height: 24),
            const Text(
              '잠시만 기다려주세요...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '데이터를 불러오는 중입니다',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
