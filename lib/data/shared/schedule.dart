import 'package:flutter_onjung_v1/data/shared/activity.dart';

class Schedule {
  final String id;
  final DateTime date;
  final String title;
  final List<Activity> activities;
  final bool isCompleted;

  Schedule({
    required this.id,
    required this.date,
    required this.title,
    required this.activities,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'activities': activities.map((activity) => activity.toJson()).toList(),
      'isCompleted': isCompleted,
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      activities: (json['activities'] as List)
          .map((activity) => Activity.fromJson(activity))
          .toList(),
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
