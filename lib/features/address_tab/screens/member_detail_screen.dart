// member_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'member_history_tab.dart';
import 'member_profile_tab.dart';

class MemberDetailScreen extends StatelessWidget {
  const MemberDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // extra 데이터 받기
    final extra = GoRouter.of(context).state?.extra as Map<String, dynamic>?;
    final data = extra?['data'] as Map<String, dynamic>; // 리스트 아이템의 전체 데이터

    // data에서 필요한 정보 추출
    final name = data['counterpart'] ?? 'Unknown';
    final relation = data['relation'] ?? '';
    final relationDetail = data['relation_detail'] ?? '';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(name), // 전달받은 이름 표시
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            // Summary Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('친타이밍 - ${name}님과',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('2024년 3월 ~ 2024년 5월',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('5월', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text('(10/13 1차)',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('500,000원',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text('(받은 300,000원 / 보낸 200,000원)',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),
            // Tab Bar
            Container(
              color: Colors.grey[200],
              child: TabBar(
                tabs: const [
                  Tab(text: '내역'),
                  Tab(text: '프로필'),
                ],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
              ),
            ),
            // Tab View
            const Expanded(
              child: TabBarView(
                children: [
                  MemberHistoryTab(),
                  MemberProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class MemberDetailScreen extends StatelessWidget {
//   const MemberDetailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // 전달된 데이터 수신
//     final extra = GoRouter.of(context).state?.extra as Map<String, dynamic>?;
//     final memberId = extra?['memberId'];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('상세 정보 - 사용자 $memberId'),
//       ),
//       body: Center(
//         child: Text(
//           '사용자 $memberId의 상세 정보 화면입니다.',
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
