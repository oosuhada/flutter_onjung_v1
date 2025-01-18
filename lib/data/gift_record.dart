// models/gift_record.dart
class GiftRecord {
  final int? id;
  final int amount;
  final String receiverName;
  final bool isSent; // true: 보낸 돈, false: 받은 돈
  final String eventType;
  final DateTime date;
  final bool? didVisit;
  final String? gift;
  final String? memo;
  final String? contact;

  GiftRecord({
    this.id,
    required this.amount,
    required this.receiverName,
    required this.isSent,
    required this.eventType,
    required this.date,
    this.didVisit,
    this.gift,
    this.memo,
    this.contact,
  });

  // Map<String, dynamic>로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'receiverName': receiverName,
      'isSent': isSent ? 1 : 0, // Boolean을 정수로 변환
      'eventType': eventType,
      'date': date.toIso8601String(), // DateTime을 String으로 변환
      'didVisit': didVisit,
      'gift': gift,
      'memo': memo,
      'contact': contact,
    };
  }

  // Map<String, dynamic>로부터 GiftRecord 객체 생성
  factory GiftRecord.fromMap(Map<String, dynamic> map) {
    return GiftRecord(
      id: map['id'],
      amount: map['amount'],
      receiverName: map['receiverName'],
      isSent: map['isSent'] == 1, // 정수를 Boolean으로 변환
      eventType: map['eventType'],
      date: DateTime.parse(map['date']),
      didVisit: map['didVisit'],
      gift: map['gift'],
      memo: map['memo'],
      contact: map['contact'],
    );
  }
}
