import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent, // 백그라운드 색상 제거
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) => const LoginOptionsDialog(),
            );
          },
          child: const Text("로그인 옵션 보기"),
        ),
      ),
    );
  }
}

class LoginOptionsDialog extends StatelessWidget {
  const LoginOptionsDialog({super.key});

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
                    color: Colors.yellow,
                    icon: Icons.chat_bubble,
                    onTap: () {
                      // 카카오 로그인 처리
                    },
                  ),
                  _buildCircleButton(
                    color: Colors.green,
                    icon: Icons.tag_faces,
                    onTap: () {
                      // 네이버 로그인 처리
                    },
                  ),
                  _buildCircleButton(
                    color: Colors.blue,
                    icon: Icons.g_translate,
                    onTap: () {
                      // 구글 로그인 처리
                    },
                  ),
                  _buildCircleButton(
                    color: Colors.black,
                    icon: Icons.apple,
                    onTap: () {
                      // 애플 로그인 처리
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32), // 소셜 로그인 버튼 간격 조정
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  // 이메일 로그인 처리
                },
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
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56, // 버튼 크기 조정
        height: 56,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
