import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context
                .pop(); // context.goNamed(AppRoute.onboarding.name) 대신 pop() 사용
          },
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
              color: Colors.yellow,
              textColor: Colors.black,
              text: "카카오로 계속하기",
              icon: Icons.chat_bubble,
              onTap: () {
                // 카카오 로그인 처리
              },
            ),
            const SizedBox(height: 16),
            _buildSocialButton(
              color: Colors.green,
              textColor: Colors.white,
              text: "네이버로 계속하기",
              icon: Icons.tag_faces,
              onTap: () {
                // 네이버 로그인 처리
              },
            ),
            const SizedBox(height: 16),
            _buildSocialButton(
              color: Colors.white,
              textColor: Colors.black,
              text: "구글로 계속하기",
              icon: Icons.g_translate,
              onTap: () {
                // 구글 로그인 처리
              },
              border: true,
            ),
            const SizedBox(height: 16),
            _buildSocialButton(
              color: Colors.black,
              textColor: Colors.white,
              text: "Apple로 계속하기",
              icon: Icons.apple,
              onTap: () {
                // 애플 로그인 처리
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
              icon: Icons.email,
              onTap: () {
                // 이메일 회원가입 처리
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required Color color,
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    Color? textColor,
    bool border = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          side: border
              ? const BorderSide(color: Colors.grey, width: 1)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: Icon(icon, color: textColor),
        label: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
      ),
    );
  }
}
