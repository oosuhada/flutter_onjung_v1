import 'package:flutter_onjung_v1/data/my_onjung_tab/guest_details.dart';
import 'package:flutter_onjung_v1/data/shared/unified_transaction.dart';

class Event {
  final String eventId; // 이벤트 고유 ID
  final String type; // 이벤트 종류 (예: 결혼식, 장례식 등)
  final String title; // 이벤트 제목
  final DateTime date; // 날짜
  final String location; // 장소
  final int totalAmount; // 경조사비 총액
  final String imageUrl; // 이미지 경로
  final int guestCount; // 예상 인원
  final List<GuestDetails> guestDetails; // 방문자 목록
  final List<UnifiedTransaction> transactions; // 축의금 트랜잭션

  Event({
    required this.eventId,
    required this.type,
    required this.title,
    required this.date,
    required this.location,
    required this.totalAmount,
    required this.imageUrl,
    required this.guestCount,
    required this.guestDetails,
    required this.transactions,
  });

  // JSON에서 Event 객체를 생성하는 팩토리 생성자
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['eventId'],
      type: json['type'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      totalAmount: json['totalAmount'],
      imageUrl: json['imageUrl'],
      guestCount: json['guestCount'],
      guestDetails: (json['guestDetails'] as List)
          .map((guest) => GuestDetails.fromJson(guest))
          .toList(),
      transactions: (json['transactions'] as List)
          .map((transaction) => UnifiedTransaction.fromJson(transaction))
          .toList(),
    );
  }

  // Event 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'type': type,
      'title': title,
      'date': date.toIso8601String(),
      'location': location,
      'totalAmount': totalAmount,
      'imageUrl': imageUrl,
      'guestCount': guestCount,
      'guestDetails': guestDetails.map((guest) => guest.toJson()).toList(),
      'transactions':
          transactions.map((transaction) => transaction.toJson()).toList(),
    };
  }
}
