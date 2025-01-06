import 'package:flutter_onjung_v1/data/%08shared/member.dart';
import 'package:flutter_onjung_v1/data/%08shared/schedule.dart';

class Group {
  final String id; // 그룹 고유 ID
  final String title; // 그룹명 (예: "감라중학교 졸업생 49기")
  final String description; // 한줄 소개
  final DateTime startDate; // 시작일 (예: 2024년 3월)
  final DateTime endDate; // 종료일 (예: 2024년 5월)
  final int totalSessions; // 총 회차 (예: 5회)
  final int regularPrice; // 본입 회비 (예: 300,000원)
  final int specialPrice; // 빈입 회비 (예: 200,000원)
  final List<Schedule> schedules; // 상세내역 (14일 오늘, 13일 화요일 등)
  final List<Member> members; // 인원 목록
  final bool isGroupAccount; // 그룹 통장 여부
  final bool isSharedAccount; // 승낙회 여부
  int memberCount; // 인원 수 (예: 35명)

  Group({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.totalSessions,
    required this.regularPrice,
    required this.specialPrice,
    required this.schedules,
    required this.members,
    this.isGroupAccount = false,
    this.isSharedAccount = false,
  }) : memberCount = members.length; // 초기 멤버 수 설정

  // 그룹에 새로운 멤버 추가
  void addMember(Member member) {
    members.add(member);
    memberCount = members.length; // 멤버 수 업데이트
  }

  // 그룹에서 멤버 제거
  void removeMember(String memberId) {
    members.removeWhere((member) => member.id == memberId);
    memberCount = members.length; // 멤버 수 업데이트
  }

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalSessions': totalSessions,
      'regularPrice': regularPrice,
      'specialPrice': specialPrice,
      'isGroupAccount': isGroupAccount,
      'isSharedAccount': isSharedAccount,
      'memberCount': memberCount,
      'schedules': schedules.map((schedule) => schedule.toJson()).toList(),
      'members': members.map((member) => member.toJson()).toList(),
    };
  }

  // JSON 역직렬화
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      totalSessions: json['totalSessions'],
      regularPrice: json['regularPrice'],
      specialPrice: json['specialPrice'],
      isGroupAccount: json['isGroupAccount'],
      isSharedAccount: json['isSharedAccount'],
      schedules: (json['schedules'] as List)
          .map((schedule) => Schedule.fromJson(schedule))
          .toList(),
      members: (json['members'] as List)
          .map((member) => Member.fromJson(member))
          .toList(),
    );
  }
}
