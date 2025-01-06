import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onjung_v1/data/%08shared/member.dart';
import 'package:flutter_onjung_v1/data/%08shared/unified_transaction.dart';
import 'package:go_router/go_router.dart';

import 'member_history_tab.dart';
import 'member_profile_tab.dart';

// member_detail_screen.dart 수정
class MemberDetailScreen extends StatefulWidget {
  final String counterpartId;

  const MemberDetailScreen({
    super.key,
    required this.counterpartId,
  });

  @override
  State<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<MemberDetailScreen> {
  Member? memberData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMemberData();
  }

  Future<void> _loadMemberData() async {
    try {
      final String jsonString = await rootBundle
          .loadString('assets/dummy_transactions_personal.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> allTransactions = jsonData['transactions'];

      // counterpart별로 거래를 그룹화
      final Map<String, List<dynamic>> groupedTransactions = {};
      final List<String> counterpartsList = [];

      for (var transaction in allTransactions) {
        final counterpart = transaction['counterpart'];
        if (!groupedTransactions.containsKey(counterpart)) {
          groupedTransactions[counterpart] = [];
          counterpartsList.add(counterpart);
        }
        groupedTransactions[counterpart]!.add(transaction);
      }

      final int index = int.tryParse(widget.counterpartId) ?? -1;
      if (index < 0 || index >= counterpartsList.length) {
        throw Exception('Invalid counterpart ID');
      }

      final String targetCounterpart = counterpartsList[index];
      final transactions = groupedTransactions[targetCounterpart]!;
      final firstTransaction = transactions.first;

      // 트랜잭션 리스트 생성
      final transactionsList =
          transactions.map((t) => UnifiedTransaction.fromJson(t)).toList();

      // Member 객체 생성 - 트랜잭션 데이터로부터 정보 추출
      setState(() {
        memberData = Member(
          id: widget.counterpartId,
          name: targetCounterpart,
          relationship: stringToRelationship(firstTransaction['relation']),
          relationDetail: firstTransaction['relation_detail'],
          transactions: transactionsList,
          registeredDate: DateTime.parse(firstTransaction['date']),
        );
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading member data: $e');
      setState(() {
        memberData = null;
        isLoading = false;
      });
    }
  }

  Relationship stringToRelationship(String relation) {
    switch (relation) {
      case '가족':
        return Relationship.family;
      case '친구':
        return Relationship.friend;
      case '동료':
        return Relationship.coworker;
      default:
        return Relationship.other;
    }
  }

  // build 메서드는 이전과 동일하게 유지
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (memberData == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Text('Member not found'),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(memberData!.name),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: TabBarView(
          children: [
            MemberHistoryTab(counterpartId: memberData!.id),
            MemberProfileTab(counterpartId: memberData!.id),
          ],
        ),
        bottomNavigationBar: const TabBar(
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: '내역', icon: Icon(Icons.history)),
            Tab(text: '프로필', icon: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }
}
