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
    final String jsonString =
        await rootBundle.loadString('assets/dummy_transactions_group.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      _groupData = jsonData;
    });
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
                group['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '멤버 ${group['memberCount']}명',
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: const Icon(Icons.chevron_right),
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
