// group_list_section.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupListSection extends StatefulWidget {
  const GroupListSection({Key? key}) : super(key: key);

  @override
  _GroupListSectionState createState() => _GroupListSectionState();
}

class _GroupListSectionState extends State<GroupListSection> {
  List<dynamic> _groupData = [];

  @override
  void initState() {
    super.initState();
    _loadGroupData();
  }

  Future<void> _loadGroupData() async {
    try {
      // JSON 파일 읽기
      final String jsonString =
          await rootBundle.loadString('assets/dummy_transactions_group.json');

      // JSON 디코딩
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // 'communities' 키를 통해 그룹 데이터를 가져옴
      if (jsonData.containsKey('communities')) {
        setState(() {
          _groupData = jsonData['communities'] as List<dynamic>;
        });
      } else {
        throw Exception('Invalid JSON structure: "communities" key not found');
      }
    } catch (e) {
      debugPrint('Error loading group data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          itemCount: _groupData.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final group = _groupData[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.group, color: Colors.grey),
              ),
              title: Text(
                group['name'], // 그룹 이름
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '멤버 ${group['memberCount']}명', // 멤버 수
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // 멤버 정보를 출력하거나 다른 화면으로 이동
                debugPrint('Tapped on group: ${group['name']}');
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
            label: const Text('+ 그룹 등록'),
          ),
        ),
      ],
    );
  }
}
