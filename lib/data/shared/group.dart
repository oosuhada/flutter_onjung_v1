// 그룹 타입 정의
enum GroupType {
  schoolAlumni('동창회'), // 학교 동창회
  workAlumni('동문회'), // 직장 동문회
  hobby('동호회'), // 취미 모임
  neighborhood('친목회'), // 지역 모임
  family('가족모임'), // 가족 모임
  other('기타'); // 기타 모임

  final String koreanName;
  const GroupType(this.koreanName);
}

// 그룹 멤버 정보
class GroupMember {
  final String groupMemberId; // 고유 식별자
  final String groupMemberName; // 이름
  final String groupMemberPhoneNumber; // 전화번호
  final int? groupMemberAge; // 나이 (선택)
  final String? groupMemberRegion; // 지역 (선택)
  final String? groupMemberMemo; // 메모 (선택)
  final DateTime groupMemberJoinedDate; // 그룹 가입일
  final List<GroupTransaction> groupMemberTransactions; // 해당 멤버와의 경조사 거래 내역

  GroupMember({
    required this.groupMemberId,
    required this.groupMemberName,
    required this.groupMemberPhoneNumber,
    this.groupMemberAge,
    this.groupMemberRegion,
    this.groupMemberMemo,
    required this.groupMemberJoinedDate,
    this.groupMemberTransactions = const [],
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      groupMemberId:
          json['groupMemberId'] ?? json['phone'] ?? '', // phone을 id로 사용할 수 있음
      groupMemberName: json['groupMemberName'] ?? '',
      groupMemberPhoneNumber: json['phone'] ?? '',
      groupMemberAge: json['groupMemberAge'],
      groupMemberRegion: json['groupMemberRegion'],
      groupMemberMemo: json['groupMemberMemo'],
      groupMemberJoinedDate: json['groupMemberJoinedDate'] != null
          ? DateTime.parse(json['groupMemberJoinedDate'])
          : DateTime.now(),
      groupMemberTransactions: (json['groupMemberTransactions'] as List?)
              ?.map((tx) => GroupTransaction.fromJson(tx))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'groupMemberId': groupMemberId,
        'groupMemberName': groupMemberName,
        'groupMemberPhoneNumber': groupMemberPhoneNumber,
        'groupMemberAge': groupMemberAge,
        'groupMemberRegion': groupMemberRegion,
        'groupMemberMemo': groupMemberMemo,
        'groupMemberJoinedDate': groupMemberJoinedDate.toIso8601String(),
        'groupMemberTransactions':
            groupMemberTransactions.map((tx) => tx.toJson()).toList(),
      };
}

// 경조사 거래 내역
class GroupTransaction {
  final String groupTransactionId; // 고유 식별자
  final DateTime groupTransactionDate; // 거래 날짜
  final String groupTransactionEventType; // 결혼, 장례, 생일 등
  final double groupTransactionAmount; // 금액
  final String? groupTransactionMemo; // 메모 (선택)
  final bool groupTransactionIsReceived; // true: 받은 돈, false: 보낸 돈

  GroupTransaction({
    required this.groupTransactionId,
    required this.groupTransactionDate,
    required this.groupTransactionEventType,
    required this.groupTransactionAmount,
    this.groupTransactionMemo,
    required this.groupTransactionIsReceived,
  });

  factory GroupTransaction.fromJson(Map<String, dynamic> json) {
    return GroupTransaction(
      groupTransactionId: json['groupTransactionId'] ?? '',
      groupTransactionDate: DateTime.parse(json['groupTransactionDate']),
      groupTransactionEventType: json['groupTransactionEventType'] ?? '',
      groupTransactionAmount:
          (json['groupTransactionAmount'] as num).toDouble(),
      groupTransactionMemo: json['groupTransactionMemo'],
      groupTransactionIsReceived: json['groupTransactionIsReceived'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'groupTransactionId': groupTransactionId,
        'groupTransactionDate': groupTransactionDate.toIso8601String(),
        'groupTransactionEventType': groupTransactionEventType,
        'groupTransactionAmount': groupTransactionAmount,
        'groupTransactionMemo': groupTransactionMemo,
        'groupTransactionIsReceived': groupTransactionIsReceived,
      };
}

// 메인 그룹 클래스
class SocialGroup {
  final String groupId; // 고유 식별자
  final String groupName; // 그룹명
  final String groupDescription; // 그룹 설명
  final GroupType groupType; // 그룹 유형
  final DateTime groupCreatedDate; // 그룹 생성일
  final List<GroupMember> groupMembers; // 그룹 멤버 목록

  // 계산된 속성
  int get groupMemberCount => groupMembers.length;

  // 최근 거래 내역을 가져오는 getter
  List<GroupTransaction> get recentGroupTransactions {
    final allTransactions = groupMembers
        .expand((member) => member.groupMemberTransactions)
        .toList()
      ..sort(
          (a, b) => b.groupTransactionDate.compareTo(a.groupTransactionDate));

    return allTransactions.take(10).toList(); // 최근 10개
  }

  SocialGroup({
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    required this.groupType,
    required this.groupCreatedDate,
    required this.groupMembers,
  });

  factory SocialGroup.fromJson(Map<String, dynamic> json) {
    return SocialGroup(
      groupId: json['groupId'] ?? json['groupName'] ?? '',
      groupName: json['groupName'] ?? '',
      groupDescription: json['groupDescription'] ?? '',
      groupType: _parseGroupType(json['groupType']),
      groupCreatedDate: json['groupCreatedDate'] != null
          ? DateTime.parse(json['groupCreatedDate'])
          : DateTime.now(),
      groupMembers: (json['groupMembers'] as List?)
              ?.map((member) => GroupMember.fromJson(member))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        'groupName': groupName,
        'groupDescription': groupDescription,
        'groupType': groupType.name,
        'groupCreatedDate': groupCreatedDate.toIso8601String(),
        'groupMembers': groupMembers.map((member) => member.toJson()).toList(),
      };

  static GroupType _parseGroupType(String? type) {
    if (type == null) return GroupType.other;
    try {
      return GroupType.values.firstWhere(
        (e) => e.name == type || e.koreanName == type,
        orElse: () => GroupType.other,
      );
    } catch (_) {
      return GroupType.other;
    }
  }
}
