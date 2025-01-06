// import 'package:flutter/material.dart';
// import 'package:flutter_onjung_v1/core/config/app_router.dart';
// import 'package:go_router/go_router.dart';

// class PersonalTab extends StatelessWidget {
//   const PersonalTab({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: 10, // 예시 데이터 개수
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text('사용자 $index'),
//           subtitle: Text('사용자 상세 정보를 확인하려면 클릭하세요.'),
//           onTap: () {
//             // MemberDetailScreen으로 이동
//             context.push(
//               AppRoute.memberDetail.path,
//               extra: {'memberId': index}, // 예제 데이터 전달
//             );
//           },
//         );
//       },
//     );
//   }
// }

// personal_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/address_tab/main_screen_components/personal_header_section.dart';
import 'package:flutter_onjung_v1/features/address_tab/main_screen_components/personal_list_section.dart';

class PersonalTab extends StatefulWidget {
  const PersonalTab({Key? key}) : super(key: key);

  @override
  _PersonalTabState createState() => _PersonalTabState();
}

class _PersonalTabState extends State<PersonalTab> {
  String _sortOption = 'name';

  void _onSortChanged(String sortOption) {
    setState(() {
      _sortOption = sortOption;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PersonalHeaderSection(
          nickname: "르탄이",
          totalContacts: 256,
          sortOption: _sortOption,
          onSortChanged: _onSortChanged,
        ),
        Expanded(
          child: PersonalListSection(
            sortOption: _sortOption,
          ),
        ),
      ],
    );
  }
}
