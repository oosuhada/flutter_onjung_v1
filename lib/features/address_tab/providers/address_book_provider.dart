import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onjung_v1/data/shared/group.dart';
import 'package:flutter_onjung_v1/data/shared/member.dart';
import 'package:flutter_onjung_v1/data/shared/unified_transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 기본 AddressBook 관리를 위한 프로바이더
class AddressBookProvider with ChangeNotifier {
  List<Member> _members = [];
  final List<SocialGroup> _groups = [];
  String _nickname = '르탄이'; // 기본 사용자 닉네임 값
  bool _isInitialized = false; // 초기화 상태 추적
  bool get isInitialized => _isInitialized;

  AddressBookProvider() {
    // 생성자에서 데이터 로딩 시작
    _initializeData();
  }

  // 초기화 메서드
  Future<void> _initializeData() async {
    if (!_isInitialized) {
      await loadMembersFromTransactions();
      await loadGroupsFromTransactions();
      _isInitialized = true;
    }
  }

  List<Member> get members => [..._members];
  List<SocialGroup> get groups => [..._groups];
  // 내 닉네임을 가져오는 getter
  String get nickname => _nickname;

  // 내 닉네임을 설정하는 setter
  // 닉네임이 변경될 때마다 UI에 알림
  set nickname(String value) {
    _nickname = value;
    notifyListeners();
  }

  // 데이터 리로드 메서드 추가
  Future<void> reloadData() async {
    await loadMembersFromTransactions();
    await loadGroupsFromTransactions();
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

  void addGroup(SocialGroup group) {
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

  Future<void> loadGroupsFromTransactions() async {
    try {
      debugPrint('🔄 Starting to load groups...');
      final String jsonString =
          await rootBundle.loadString('assets/dummy_transactions_group.json');
      debugPrint('📄 JSON loaded successfully');

      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> groupsData = jsonData['communities'] as List<dynamic>;
      _groups.clear();

      for (var groupData in groupsData) {
        // 거래 내역을 GroupTransaction으로 변환
        final transactions = (groupData['transactions'] as List<dynamic>?)
                ?.map((txnData) => GroupTransaction(
                      groupTransactionId: txnData['groupTransactionId'],
                      groupTransactionDate:
                          DateTime.parse(txnData['groupTransactionDate']),
                      groupTransactionAmount:
                          txnData['groupTransactionAmount'].toDouble(),
                      groupTransactionEventType:
                          txnData['groupTransactionEventType'],
                      groupTransactionMemo: txnData['groupTransactionMemo'],
                      groupTransactionIsReceived:
                          txnData['groupTransactionIsReceived'],
                    ))
                .toList() ??
            [];

        // 모든 멤버에게 동일한 거래 내역을 할당
        final members = (groupData['members'] as List<dynamic>?)
                ?.map((memberData) => GroupMember(
                      groupMemberId: memberData['groupMemberId']?.toString() ??
                          memberData['phone']?.toString() ??
                          '', // phone을 fallback ID로 사용
                      groupMemberName:
                          memberData['name']?.toString() ?? 'Unknown',
                      groupMemberPhoneNumber:
                          memberData['phone']?.toString() ?? '',
                      groupMemberAge: memberData['age'] as int?,
                      groupMemberRegion: memberData['region']?.toString(),
                      groupMemberJoinedDate: DateTime.now(),
                      groupMemberTransactions: transactions, // 각 멤버에게 거래 내역 할당
                    ))
                .toList() ??
            [];

        final groupName = groupData['name']?.toString() ?? 'Unknown Group';
        _groups.add(SocialGroup(
          groupId: groupName, // 그룹 이름을 ID로 사용
          groupName: groupName,
          groupDescription: groupData['description']?.toString() ?? '설명이 없습니다.',
          groupType: _determineGroupType(groupName),
          groupCreatedDate: DateTime.now(),
          groupMembers: members,
        ));
      }

      debugPrint('Successfully loaded ${_groups.length} groups');
      _isInitialized = true;
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Error loading groups from transactions: $e');
      debugPrint('Stack trace: $stackTrace');
      _groups.clear();
      _isInitialized = true;
      notifyListeners();
    }
  }

// 그룹 이름에서 타입을 추정하는 헬퍼 메서드
  GroupType _determineGroupType(String groupName) {
    groupName = groupName.toLowerCase();
    if (groupName.contains('초등학교') ||
        groupName.contains('중학교') ||
        groupName.contains('고등학교') ||
        groupName.contains('대학교')) {
      return GroupType.schoolAlumni;
    } else if (groupName.contains('동문회')) {
      return GroupType.workAlumni;
    } else if (groupName.contains('동호회')) {
      return GroupType.hobby;
    } else if (groupName.contains('가족')) {
      return GroupType.family;
    } else {
      return GroupType.other;
    }
  }

// 닉네임으로 총 그룹 수 조회
  int getTotalGroupsForNickname(String nickname) {
    return _groups.where((group) {
      return group.groupMembers
          .any((member) => member.groupMemberName == nickname);
    }).length;
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
