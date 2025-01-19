import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onjung_v1/features/address_tab/detailed_screens/group_history_tab.dart';
import 'package:flutter_onjung_v1/features/address_tab/detailed_screens/group_profile_tab.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;
  final List transactions;

  const GroupDetailScreen({
    Key? key,
    required this.groupId,
    required this.transactions,
  }) : super(key: key);

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  Map<String, dynamic>? groupData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroupData();
  }

  Future<void> _loadGroupData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/dummy_transactions_group.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // 그룹 이름으로 검색하도록 수정
      final group = jsonData['communities']?.firstWhere(
        (g) => g['name'] == widget.groupId,
        orElse: () => null,
      );

      setState(() {
        groupData = group;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading group data: $e');
      setState(() {
        groupData = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (groupData == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: Text('Group not found'),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(groupData!['name'] ?? 'Unknown Group'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: TabBarView(
          children: [
            GroupHistoryTab(groupId: widget.groupId),
            GroupProfileTab(groupId: widget.groupId),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(text: '내역', icon: Icon(Icons.history)),
            Tab(text: '프로필', icon: Icon(Icons.group)),
          ],
        ),
      ),
    );
  }
}
