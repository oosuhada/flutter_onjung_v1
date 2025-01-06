import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onjung_v1/data/%08shared/group.dart';
import 'package:flutter_onjung_v1/data/%08shared/member.dart';
import 'package:flutter_onjung_v1/data/%08shared/unified_transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 기본 AddressBook 관리를 위한 프로바이더
class AddressBookProvider with ChangeNotifier {
  List<Member> _members = [];
  List<Group> _groups = [];
  String _nickname = '르탄이'; // 기본 사용자 닉네임 값

  List<Member> get members => [..._members];
  List<Group> get groups => [..._groups];
  // 내 닉네임을 가져오는 getter
  String get nickname => _nickname;

  // 내 닉네임을 설정하는 setter
  // 닉네임이 변경될 때마다 UI에 알림
  set nickname(String value) {
    _nickname = value;
    notifyListeners();
  }

  // 상대방의 ID로 해당 상대방의 닉네임을 조회하는 함수
  // memberId가 존재하지 않을 경우 '알 수 없음'으로 표시
  String getNickname(String memberId) {
    final member = _members.firstWhere(
      (member) => member.id == memberId,
      orElse: () => Member(
        id: memberId,
        name: '알 수 없음',
        registeredDate: DateTime.now(),
        relationship: Relationship.other,
        relationDetail: '',
        transactions: [],
      ),
    );
    return member.name;
  }

  void addMember(Member member) {
    _members.add(member);
    notifyListeners();
  }

  void addGroup(Group group) {
    _groups.add(group);
    notifyListeners();
  }

  // Add method to load members from transactions
  Future<void> loadMembersFromTransactions() async {
    try {
      final String jsonString = await rootBundle
          .loadString('assets/dummy_transactions_personal.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> transactions = jsonData['transactions'] as List;

      // Group transactions by counterpart
      final Map<String, List<dynamic>> groupedTransactions = {};
      for (var transaction in transactions) {
        final counterpart = transaction['counterpart'] as String;
        if (!groupedTransactions.containsKey(counterpart)) {
          groupedTransactions[counterpart] = [];
        }
        groupedTransactions[counterpart]!.add(transaction);
      }

      // Create Member objects
      _members = groupedTransactions.entries.map((entry) {
        final firstTransaction = entry.value.first;
        final transactions =
            entry.value.map((t) => UnifiedTransaction.fromJson(t)).toList();

        return Member(
          id: firstTransaction['id'] as String,
          name: entry.key,
          registeredDate: DateTime.parse(firstTransaction['date']),
          relationship: _stringToRelationship(
              firstTransaction['relation'] as String? ?? '기타'),
          relationDetail: firstTransaction['relation_detail'] as String? ?? '',
          transactions: transactions,
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading members from transactions: $e');
    }
  }

  Relationship _stringToRelationship(String relation) {
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
}

// 현재 선택된 멤버 관리를 위한 프로바이더
class SelectedMemberNotifier extends StateNotifier<Member?> {
  SelectedMemberNotifier() : super(null);

  Future<void> selectMember(String memberId) async {
    try {
      final String jsonString = await rootBundle
          .loadString('assets/dummy_transactions_personal.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> filteredTransactions =
          (jsonData['transactions'] as List)
              .where((transaction) => transaction['id'] == memberId)
              .toList();

      if (filteredTransactions.isEmpty) {
        state = null;
        return;
      }

      final firstTransaction = filteredTransactions.first;
      final List<UnifiedTransaction> unifiedTransactions = filteredTransactions
          .map((transaction) => UnifiedTransaction.fromJson(transaction))
          .toList();

      state = Member(
        id: memberId,
        name: firstTransaction['counterpart'] as String? ?? '알 수 없음',
        registeredDate: firstTransaction['registered_date'] != null
            ? DateTime.parse(firstTransaction['registered_date'])
            : DateTime.now(),
        relationship: Relationship.friend,
        relationDetail: firstTransaction['relation_detail'] as String? ?? '',
        transactions: unifiedTransactions,
      );
    } catch (e) {
      debugPrint('Error selecting member: $e');
      state = null;
    }
  }

  void clearSelection() {
    state = null;
  }
}

// 선택된 멤버 ID를 위한 프로바이더
final currentMemberIdProvider = StateProvider<String?>((ref) => null);
