class Activity {
  final String id;
  final String type; // 활동 유형: 예) 생일, 결혼식 등
  final String description; // 활동에 대한 설명
  final int amount; // 관련 금액
  final bool isCompleted; // 활동 완료 여부
  final DateTime? completedAt; // 완료된 날짜

  Activity({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    this.isCompleted = false,
    this.completedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'amount': amount,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      amount: json['amount'],
      isCompleted: json['isCompleted'],
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }
}
