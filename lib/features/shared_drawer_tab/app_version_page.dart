// app_version_page.dart
import 'package:flutter/material.dart';

class AppVersionPage extends StatelessWidget {
  const AppVersionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('앱 버전 정보'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'assets/logo_clear_white.png' // 다크 테마일 때 로고 이미지 경로
                  : 'assets/logo_clear.png', // 라이트 테마일 때 로고 이미지 경로
              width: 130, // 원하는 너비로 조정
              height: 60, // 원하는 높이로 조정
              fit: BoxFit.contain, // 이미지를 컨테이너에 맞게 조정
            ),
            const SizedBox(height: 16),
            const Text(
              '현재 버전: 1.0.0',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              '최신 버전: 1.0.0',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: 업데이트 확인 로직 구현
              },
              child: const Text('업데이트 확인'),
            ),
          ],
        ),
      ),
    );
  }
}
