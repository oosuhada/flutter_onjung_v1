import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onjung_v1/core/auth_services/firebase_auth_service.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "간편 로그인으로\n빠르게 가입하세요",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            _buildSocialButton(
              color: const Color(0xFFFEDC3F),
              textColor: Colors.black,
              text: "카카오로 계속하기",
              assetPath: 'assets/logo/kakao_logo.png',
              onTap: () {
                // 카카오 회원가입 구현 예정
              },
            ),
            const SizedBox(height: 16),
            _buildSocialButton(
              color: const Color(0xFF03C75A),
              textColor: Colors.white,
              text: "네이버로 계속하기",
              assetPath: 'assets/logo/naver_logo.png',
              onTap: () {
                // 네이버 회원가입 구현 예정
              },
            ),
            const SizedBox(height: 16),
            _buildSocialButton(
              color: Colors.white,
              textColor: Colors.black,
              text: "구글로 계속하기",
              assetPath: 'assets/logo/logo_google.png',
              onTap: () => _handleGoogleSignUp(context),
              border: true,
            ),
            const SizedBox(height: 16),
            _buildSocialButton(
              color: Colors.black,
              textColor: Colors.white,
              text: "Apple로 계속하기",
              assetPath: 'assets/logo/logo_apple.png',
              onTap: () {
                // 애플 회원가입 구현 예정
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("또는", style: TextStyle(color: Colors.grey)),
                ),
                Expanded(child: Divider(thickness: 1)),
              ],
            ),
            const SizedBox(height: 24),
            _buildSocialButton(
              color: Colors.black,
              textColor: Colors.white,
              text: "이메일로 계속하기",
              assetPath: null,
              onTap: () => _navigateToEmailSignUp(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required Color color,
    required Color textColor,
    required String text,
    required VoidCallback onTap,
    String? assetPath,
    bool border = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          side: border
              ? const BorderSide(color: Colors.grey, width: 1)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (assetPath != null) ...[
              Image.asset(
                assetPath,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignUp(BuildContext context) async {
    try {
      final authService = ref.read(authServiceProvider);
      final userCredential = await authService.signInWithGoogle();

      if (userCredential != null && context.mounted) {
        context.go(AppRoute.profileSetup.path);
      }
    } on PlatformException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('구글 로그인 설정 오류: ${e.message}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      debugPrint('Google Sign In PlatformException: ${e.message}');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('구글 회원가입 중 오류가 발생했습니다.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      debugPrint('Google Sign In Error: $e');
    }
  }

  void _navigateToEmailSignUp(BuildContext context) {
    context.push(AppRoute.emailSignup.path); // go() 대신 push() 사용
  }
}
