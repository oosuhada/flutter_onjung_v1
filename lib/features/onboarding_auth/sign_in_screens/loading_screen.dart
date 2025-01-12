import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/auth_services/auth_token_service.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:flutter_onjung_v1/core/other_services/version_check_service.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/providers/user_profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  String _loadingMessage = '데이터를 불러오는 중입니다';

  @override
  void initState() {
    super.initState();
    _checkVersionAndAuth();
  }

  Future<void> _checkVersionAndAuth() async {
    try {
      // 1. 앱 버전 확인
      setState(() => _loadingMessage = '앱 버전 확인 중...');
      await Future.delayed(const Duration(seconds: 1)); // 메시지 표시 시간 추가
      final versionService = VersionCheckService();
      final needsUpdate = await versionService.checkForUpdate();

      if (needsUpdate) {
        if (!mounted) return;
        await _showUpdateDialog();
        return;
      }

      // 2. 로그인 상태 확인
      setState(() => _loadingMessage = '로그인 상태 확인 중...');
      await Future.delayed(const Duration(seconds: 1)); // 메시지 표시 시간 추가
      final authToken = ref.read(authTokenProvider);
      final userProfile = ref.read(userProfileProvider.notifier);

      final isLoggedIn = await authToken.checkAutoLogin();

      if (!mounted) return;

      // 3. 사용자 정보 불러오는 중
      if (isLoggedIn) {
        setState(() => _loadingMessage = '사용자 정보 불러오는 중...');
        await Future.delayed(const Duration(seconds: 1)); // 메시지 표시 시간 추가
        await userProfile.loadProfile();

        if (mounted) {
          context.goNamed(AppRoute.homeTab.name); // 다음 페이지로 이동
        }
      } else {
        await Future.delayed(const Duration(seconds: 1)); // 메시지 표시 시간 추가
        context.goNamed(AppRoute.authOnboarding.name); // 로그인 페이지로 이동
      }
    } catch (e) {
      debugPrint('확인 실패: $e');
      if (mounted) {
        _showErrorDialog();
      }
    }
  }

  Future<void> _showUpdateDialog() async {
    final storeUrl = Platform.isIOS
        ? 'https://apps.apple.com/app/id123456789' // iOS 앱스토어 URL
        : 'https://play.google.com/store/apps/details?id=com.example.app'; // Android Play스토어 URL

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('업데이트 필요'),
        content: const Text('새로운 버전이 있습니다.\n앱을 업데이트해주세요.'),
        actions: [
          TextButton(
            onPressed: () async {
              if (await canLaunchUrl(Uri.parse(storeUrl))) {
                // 스토어 URL 열기
                await launchUrl(Uri.parse(storeUrl));
              } else {
                // URL 열기에 실패한 경우
                debugPrint('스토어 URL 열기 실패: $storeUrl');
              }
            },
            child: const Text('업데이트'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('오류'),
        content: const Text('확인 중 문제가 발생했습니다.\n다시 시도해주세요.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _checkVersionAndAuth();
            },
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
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
              'assets/logo/onjung_logo_clear_dark.png',
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
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            const Text(
              '잠시만 기다려주세요...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _loadingMessage,
              style: const TextStyle(
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
