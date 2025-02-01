import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MemberDetailScreen extends StatelessWidget {
  const MemberDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 전달된 데이터 수신
    final extra = GoRouter.of(context).state?.extra as Map<String, dynamic>?;
    final memberId = extra?['memberId'];

    return Scaffold(
      appBar: AppBar(
        title: Text('상세 정보 - 사용자 $memberId'),
      ),
      body: Center(
        child: Text(
          '사용자 $memberId의 상세 정보 화면입니다.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
