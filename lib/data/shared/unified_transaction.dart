import 'package:flutter_onjung_v1/data/%08shared/activity.dart';
import 'package:flutter_onjung_v1/data/%08shared/member.dart';
import 'package:flutter_onjung_v1/data/%08shared/schedule.dart';

class UnifiedTransaction {
  final String id;
  final String type; // sent, received
  final DateTime date;
  final String label; // 변경: title -> label (목적 또는 제목)
  final int amount;
  final PaymentMethod method; // 결제 방법
  final String? counterpart; // 거래 상대 이름
  final String? relation; // 거래 상대와의 관계 (예: 가족, 친구 등)
  final String? relationDetail; // 관계 상세 설명
  final Member? memberInfo; // 관련된 멤버 정보
  final Schedule? scheduleInfo; // 관련된 스케줄 정보
  final Activity? activityInfo; // 관련된 활동 정보

  UnifiedTransaction({
    required this.id,
    required this.type,
    required this.date,
    required this.label, // 변경: title -> label
    required this.amount,
    required this.method,
    this.counterpart,
    this.relation,
    this.relationDetail,
    this.memberInfo,
    this.scheduleInfo,
    this.activityInfo,
  });

  // JSON 변환 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'date': date.toIso8601String(),
      'label': label, // 변경: title -> label
      'amount': amount,
      'method': method.name,
      'counterpart': counterpart,
      'relation': relation,
      'relationDetail': relationDetail,
      'memberInfo': memberInfo?.toJson(),
      'scheduleInfo': scheduleInfo?.toJson(),
      'activityInfo': activityInfo?.toJson(),
    };
  }

  // JSON 역직렬화 메서드
  factory UnifiedTransaction.fromJson(Map<String, dynamic> json) {
    // Member 정보를 트랜잭션 데이터에서 생성
    final memberInfo = Member(
      id: json['id'],
      name: json['counterpart'] ?? '',
      relationship: stringToRelationship(json['relation'] ?? ''),
      relationDetail: json['relation_detail'],
      transactions: [], // 빈 리스트로 초기화
      registeredDate: DateTime.parse(json['date']),
    );

    return UnifiedTransaction(
      id: json['id'],
      type: json['type'],
      date: DateTime.parse(json['date']),
      label: json['label'],
      amount: json['amount'],
      method: PaymentMethodExtension.fromName(json['paymentMethod'] ?? 'other'),
      counterpart: json['counterpart'],
      relation: json['relation'],
      relationDetail: json['relation_detail'],
      memberInfo: memberInfo,
      scheduleInfo: json['scheduleInfo'] != null
          ? Schedule.fromJson(json['scheduleInfo'])
          : null,
      activityInfo: json['activityInfo'] != null
          ? Activity.fromJson(json['activityInfo'])
          : null,
    );
  }

// Relationship enum을 String으로 변환하는 헬퍼 메서드 추가
  static Relationship stringToRelationship(String relation) {
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

enum PaymentMethod {
  cash, // 현금
  card, // 카드
  bankTransfer, // 계좌 이체
  other // 기타 결제 수단
}

extension PaymentMethodExtension on PaymentMethod {
  // 이름으로 PaymentMethod를 반환하는 메서드
  static PaymentMethod fromName(String name) {
    return PaymentMethod.values.firstWhere(
      (e) => e.name == name,
      orElse: () => PaymentMethod.other,
    );
  }

  // PaymentMethod를 String으로 반환하는 메서드
  String toReadableString() {
    switch (this) {
      case PaymentMethod.cash:
        return '현금';
      case PaymentMethod.card:
        return '카드';
      case PaymentMethod.bankTransfer:
        return '계좌 이체';
      case PaymentMethod.other:
        return '기타';
    }
  }
}
