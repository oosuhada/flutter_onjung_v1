// login_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/services/firebase_auth_service.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/signUp_screens/profile_setup_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'email_sign_in_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showLoginOptions(context, ref),
          child: const Text("로그인 옵션 보기"),
        ),
      ),
    );
  }

  void _showLoginOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => LoginOptionsDialog(ref: ref),
    );
  }
}

class LoginOptionsDialog extends StatelessWidget {
  final WidgetRef ref;

  const LoginOptionsDialog({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleButton(
                    context: context,
                    color: const Color(0xFFFEDC3F),
                    assetPath: 'assets/logo/kakao_logo.png',
                    onTap: () {
                      // 카카오 로그인 구현 예정
                    },
                  ),
                  _buildCircleButton(
                    context: context,
                    color: const Color(0xFF03C75A),
                    assetPath: 'assets/logo/naver_logo.png',
                    onTap: () {
                      // 네이버 로그인 구현 예정
                    },
                  ),
                  _buildCircleButton(
                    context: context,
                    color: Colors.white,
                    assetPath: 'assets/logo/logo_google.png',
                    onTap: () => _handleGoogleSignIn(context),
                  ),
                  _buildCircleButton(
                    context: context,
                    color: Colors.black,
                    assetPath: 'assets/logo/logo_apple.png',
                    onTap: () {
                      // 애플 로그인 구현 예정
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => _navigateToEmailSignIn(context),
                icon: const Icon(Icons.email),
                label: const Text("이메일로 로그인"),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required BuildContext context,
    required Color color,
    required String assetPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: color == Colors.white
              ? Border.all(color: Colors.grey.shade300)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(assetPath),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final authService = ref.read(authServiceProvider);
      final userCredential = await authService.signInWithGoogle();

      if (userCredential != null) {
        // 사용자 프로필 존재 여부 확인
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (context.mounted) {
          if (!userDoc.exists) {
            // 신규 사용자 - 프로필 설정으로 이동
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ProfileSetupScreen()),
            );
          } else {
            // 기존 사용자 - 메인 화면으로 이동
            context.go('/main');
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('구글 로그인에 실패했습니다.')),
        );
      }
    }
  }

  void _navigateToEmailSignIn(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const EmailSignInScreen()),
    );
  }
}
