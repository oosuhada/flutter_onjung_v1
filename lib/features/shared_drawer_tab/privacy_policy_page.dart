// privacy_policy_page.dart
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보 처리방침'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text(
            '1. 개인정보의 처리 목적',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('회사는 다음의 목적을 위하여 개인정보를 처리합니다...'),
          SizedBox(height: 16),
          Text(
            '2. 개인정보의 처리 및 보유 기간',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('회사는 법령에 따른 개인정보 보유·이용기간 또는...'),
          // 추가 내용...
        ],
      ),
    );
  }
}
