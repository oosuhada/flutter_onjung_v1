// 출석 내역 클래스
class AttendanceHistory {
  final String id;
  final DateTime date;
  final bool isPresent;
  final String? note;

  AttendanceHistory({
    required this.id,
    required this.date,
    required this.isPresent,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'isPresent': isPresent,
      'note': note,
    };
  }

  factory AttendanceHistory.fromJson(Map<String, dynamic> json) {
    return AttendanceHistory(
      id: json['id'],
      date: DateTime.parse(json['date']),
      isPresent: json['isPresent'],
      note: json['note'],
    );
  }
}
