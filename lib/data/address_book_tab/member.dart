import 'package:flutter_onjung_v1/data/address_book_tab/attendance_history.dart';
import 'package:flutter_onjung_v1/data/home_tab/payment_record.dart';

// 관계를 열거형으로 정의
enum Relationship {
  family, // 가족
  father, // 아버지
  mother, // 어머니
  sibling, // 형제/자매
  friend, // 친구
  highSchoolFriend, // 고등학교 친구
  collegeFriend, // 대학 친구
  coworker, // 직장 동료
  other, // 기타
}

class Member {
  final String id;
  final String name;
  final String? profileImage;
  final DateTime registeredDate; // 등록일
  final Relationship relationship; // 관계 (열거형)
  final bool isActive; // 활성 상태
  final List<PaymentRecord> paymentRecords; // 통합된 납부 내역
  final List<AttendanceHistory> attendanceHistory; // 출석 내역

  Member({
    required this.id,
    required this.name,
    this.profileImage,
    required this.registeredDate,
    required this.relationship, // 열거형 관계
    this.isActive = true,
    required this.paymentRecords,
    required this.attendanceHistory,
  });

  // JSON 직렬화 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
      'registeredDate': registeredDate.toIso8601String(),
      'relationship': relationship.name, // 열거형을 문자열로 변환
      'isActive': isActive,
      'paymentRecords':
          paymentRecords.map((record) => record.toJson()).toList(),
      'attendanceHistory':
          attendanceHistory.map((history) => history.toJson()).toList(),
    };
  }

  // JSON 역직렬화 메서드
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
      profileImage: json['profileImage'],
      registeredDate: DateTime.parse(json['registeredDate']),
      relationship: Relationship.values
          .firstWhere((e) => e.name == json['relationship']), // 문자열을 열거형으로 변환
      isActive: json['isActive'],
      paymentRecords: (json['paymentRecords'] as List)
          .map((e) => PaymentRecord.fromJson(e))
          .toList(),
      attendanceHistory: (json['attendanceHistory'] as List)
          .map((e) => AttendanceHistory.fromJson(e))
          .toList(),
    );
  }
}
