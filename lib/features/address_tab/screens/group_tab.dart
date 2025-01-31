// lib/features/address_tab/screens/group_tab.dart
import 'package:flutter/material.dart';

class GroupTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // 추후 데이터 연동
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('가족'),
          subtitle: Text('멤버 수: 4명'),
          onTap: () {
            // 그룹 상세 화면 이동 추가 가능
          },
        );
      },
    );
  }
}
