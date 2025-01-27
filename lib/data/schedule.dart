import 'package:flutter_onjung_v1/data/activity.dart';

class Schedule {
  final String id;
  final DateTime date;
  final String title; // 예: "14일 오늘", "13일 화요일"
  final int regularFee; // 본입 회비
  final int specialFee; // 빈입 회비
  final List<Activity> activities;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Schedule({
    required this.id,
    required this.date,
    required this.title,
    required this.regularFee,
    required this.specialFee,
    required this.activities,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON 직렬화 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'regularFee': regularFee,
      'specialFee': specialFee,
      'activities': activities.map((activity) => activity.toJson()).toList(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // JSON 역직렬화 메서드
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      regularFee: json['regularFee'],
      specialFee: json['specialFee'],
      activities: (json['activities'] as List)
          .map((activity) => Activity.fromJson(activity))
          .toList(),
      isCompleted: json['isCompleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
