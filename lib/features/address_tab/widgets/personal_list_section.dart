// personal_list_section.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:go_router/go_router.dart';

class PersonalListSection extends StatefulWidget {
  const PersonalListSection({Key? key}) : super(key: key);

  @override
  _PersonalListSectionState createState() => _PersonalListSectionState();
}

class _PersonalListSectionState extends State<PersonalListSection> {
  List<dynamic> _personalData = [];

  @override
  void initState() {
    super.initState();
    _loadPersonalData();
  }

  Future<void> _loadPersonalData() async {
    final String jsonString =
        await rootBundle.loadString('assets/dummy_transactions_personal.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    setState(() {
      _personalData = jsonData['transactions'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          itemCount: _personalData.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final data = _personalData[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, color: Colors.grey),
              ),
              title: Row(
                children: [
                  Text(
                    data['counterpart'] ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '1건 보냄 / 4건 받음',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              subtitle: Row(
                children: [
                  Text(
                    '${data['relation']} ${data['relation_detail'] ?? ''}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '최근 교류: ${data['last_transaction_date'] ?? '2025.01.10'}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                debugPrint('Selected item data: $data'); // 데이터 확인
                final id = data['id']?.toString() ?? '';
                context.push(
                  AppRoute.memberDetail.path,
                  extra: {
                    'data': data // 전체 데이터 객체를 전달
                  },
                );
              },
            );
          },
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor: Colors.black,
            label: const Text('+ 인원 등록'),
          ),
        ),
      ],
    );
  }
}

// class PersonalListSection extends StatefulWidget {
//   const PersonalListSection({Key? key}) : super(key: key);

//   @override
//   _PersonalListSectionState createState() => _PersonalListSectionState();
// }

// class _PersonalListSectionState extends State<PersonalListSection> {
//   List<dynamic> _personalData = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadPersonalData();
//   }

//   Future<void> _loadPersonalData() async {
//     final String jsonString =
//         await rootBundle.loadString('assets/dummy_transactions_personal.json');
//     final Map<String, dynamic> jsonData = json.decode(jsonString);

//     setState(() {
//       _personalData = jsonData['transactions']; // transactions 배열만 로드
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: _personalData.length,
//       itemBuilder: (context, index) {
//         final data = _personalData[index];
//         return ListTile(
//           leading: const CircleAvatar(
//             backgroundColor: Colors.grey,
//           ),
//           title: Text(data['counterpart'] ?? 'Unknown'), // 상대방 이름
//           subtitle: Text(
//               '${data['relation']} ${data['relation_detail'] ?? ''}'), // 관계 정보
//           trailing: Text(
//             data['type'] == 'sent'
//                 ? '보냄: ${data['amount']}원'
//                 : '받음: ${data['amount']}원',
//           ), // 거래 금액 표시
//         );
//       },
//     );
//   }
// }
