import 'unified_transaction.dart';

enum Relationship { family, friend, coworker, other }

class Member {
  final String id;
  final String name;
  final String? profileImage;
  final String? phoneNumber;
  final DateTime registeredDate;
  final Relationship relationship;
  final String? relationDetail;
  final bool isActive;
  final int? birthYear; // 출생 연도
  final DateTime? birthday; // 생일 추가
  final bool isLunar; // 음력 여부 추가
  final List<UnifiedTransaction> transactions; // 거래 내역

  Member({
    required this.id,
    required this.name,
    this.profileImage,
    this.phoneNumber,
    required this.registeredDate,
    required this.relationship,
    this.relationDetail,
    this.isActive = true,
    this.birthYear,
    this.birthday,
    this.isLunar = false,
    this.transactions = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'registeredDate': registeredDate.toIso8601String(),
      'relationship': relationship.name,
      'relationDetail': relationDetail,
      'isActive': isActive,
      'birthYear': birthYear,
      'birthday': birthday?.toIso8601String(),
      'isLunar': isLunar,
      'transactions': transactions.map((e) => e.toJson()).toList(),
    };
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
      profileImage: json['profileImage'],
      phoneNumber: json['phoneNumber'],
      registeredDate: DateTime.parse(json['registeredDate']),
      relationship: Relationship.values.firstWhere(
        (e) => e.name == json['relationship'],
        orElse: () => Relationship.other,
      ),
      relationDetail: json['relationDetail'],
      isActive: json['isActive'] ?? true,
      birthYear: json['birthYear'],
      birthday:
          json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      isLunar: json['isLunar'] ?? false,
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => UnifiedTransaction.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// import 'package:flutter_onjung_v1/data/home_tab/payment_record.dart';

// // 관계를 열거형으로 정의
// enum Relationship {
//   family, // 가족
//   friend, // 친구
//   coworker, // 직장 동료
//   other, // 기타
// }

// class Member {
//   final String id;
//   final String name;
//   final String? profileImage;
//   final String? phoneNumber; // 추가
//   final DateTime registeredDate;
//   final Relationship relationship;
//   final String? relationDetail;
//   final bool isActive;
//   final List<PaymentRecord> paymentRecords;

//   // 생일 관련 필드 추가
//   final DateTime? birthday;
//   final DateTime? lunarBirthday;
//   final int? age;

//   // 그룹 관련 필드 추가
//   final List<String> groups;

//   // 기념일 관련 필드 추가
//   final Map<String, DateTime> anniversaries;
//   final Map<String, bool> anniversaryNotifications;

//   Member({
//     required this.id,
//     required this.name,
//     this.profileImage,
//     this.phoneNumber, // 추가
//     required this.registeredDate,
//     required this.relationship,
//     this.relationDetail,
//     this.isActive = true,
//     required this.paymentRecords,
//     this.birthday,
//     this.lunarBirthday,
//     this.age,
//     this.groups = const [],
//     this.anniversaries = const {},
//     this.anniversaryNotifications = const {},
//   });

//   // JSON 변환 메서드
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'profileImage': profileImage,
//       'phoneNumber': phoneNumber, // 추가
//       'registeredDate': registeredDate.toIso8601String(),
//       'relationship': relationship.name,
//       'relationDetail': relationDetail,
//       'isActive': isActive,
//       'paymentRecords':
//           paymentRecords.map((record) => record.toJson()).toList(),
//       'birthday': birthday?.toIso8601String(),
//       'lunarBirthday': lunarBirthday?.toIso8601String(),
//       'age': age,
//       'groups': groups,
//       'anniversaries': anniversaries
//           .map((key, value) => MapEntry(key, value.toIso8601String())),
//       'anniversaryNotifications': anniversaryNotifications,
//     };
//   }

//   factory Member.fromJson(Map<String, dynamic> json) {
//     return Member(
//       id: json['id'],
//       name: json['name'],
//       profileImage: json['profileImage'],
//       phoneNumber: json['phoneNumber'],
//       registeredDate: DateTime.parse(json['registeredDate']),
//       relationship: Relationship.values.firstWhere(
//         (e) => e.name == json['relationship'],
//         orElse: () => Relationship.other, // 기본값 처리
//       ),
//       relationDetail: json['relationDetail'],
//       isActive: json['isActive'] ?? true,
//       paymentRecords: (json['paymentRecords'] as List)
//           .map((e) => PaymentRecord.fromJson(e))
//           .toList(),
//       birthday:
//           json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
//       lunarBirthday: json['lunarBirthday'] != null
//           ? DateTime.parse(json['lunarBirthday'])
//           : null,
//       age: json['age'],
//       groups: (json['groups'] as List?)?.cast<String>() ?? [],
//       anniversaries: json['anniversaries'] != null
//           ? (json['anniversaries'] as Map<String, dynamic>)
//               .map((key, value) => MapEntry(key, DateTime.parse(value)))
//           : {},
//       anniversaryNotifications:
//           (json['anniversaryNotifications'] as Map<String, dynamic>?)
//                   ?.cast<String, bool>() ??
//               {},
//     );
//   }
// }
