// TODO Implement this library.
class GuestDetails {
  final String guestId; // 게스트 ID
  final String name; // 이름
  final int? age; // 나이
  final String? phoneNumber; // 전화번호
  final String relationToHost; // 주최자와의 관계
  final String? label; // 누구와 관련된 사람인지 (예: 아버지 지인, 어머니 지인 등)
  final bool isInvited; // 초대 여부
  final bool isAttending; // 참석 여부
  final bool hasCompanion; // 동반자 여부
  final bool needsMeal; // 식사 여부
  final bool hasVehicleRegistered; // 차량 등록 여부

  GuestDetails({
    required this.guestId,
    required this.name,
    this.age,
    this.phoneNumber,
    required this.relationToHost,
    this.label,
    required this.isInvited,
    required this.isAttending,
    this.hasCompanion = false,
    this.needsMeal = false,
    this.hasVehicleRegistered = false,
  });

  // JSON 변환 메서드
  Map<String, dynamic> toJson() {
    return {
      'guestId': guestId,
      'name': name,
      'age': age,
      'phoneNumber': phoneNumber,
      'relationToHost': relationToHost,
      'label': label,
      'isInvited': isInvited,
      'isAttending': isAttending,
      'hasCompanion': hasCompanion,
      'needsMeal': needsMeal,
      'hasVehicleRegistered': hasVehicleRegistered,
    };
  }

  // JSON에서 객체 생성
  factory GuestDetails.fromJson(Map<String, dynamic> json) {
    return GuestDetails(
      guestId: json['guestId'],
      name: json['name'],
      age: json['age'],
      phoneNumber: json['phoneNumber'],
      relationToHost: json['relationToHost'],
      label: json['label'],
      isInvited: json['isInvited'],
      isAttending: json['isAttending'],
      hasCompanion: json['hasCompanion'] ?? false,
      needsMeal: json['needsMeal'] ?? false,
      hasVehicleRegistered: json['hasVehicleRegistered'] ?? false,
    );
  }
}
