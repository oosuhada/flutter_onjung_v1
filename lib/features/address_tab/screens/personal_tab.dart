import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:go_router/go_router.dart';

class PersonalTab extends StatelessWidget {
  const PersonalTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // 예시 데이터 개수
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('사용자 $index'),
          subtitle: Text('사용자 상세 정보를 확인하려면 클릭하세요.'),
          onTap: () {
            // MemberDetailScreen으로 이동
            context.push(
              AppRoute.memberDetail.path,
              extra: {'memberId': index}, // 예제 데이터 전달
            );
          },
        );
      },
    );
  }
}
