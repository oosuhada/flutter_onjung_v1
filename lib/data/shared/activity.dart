class Activity {
  final String id;
  final String type;
  final String description;
  final int amount;
  final bool isCompleted;

  Activity({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'amount': amount,
      'isCompleted': isCompleted,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      amount: json['amount'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
