// class PaymentRecord {
//   final String id;
//   final String receiverName; // 수취인 또는 송금인 이름
//   final DateTime date; // 거래 날짜
//   final int amount; // 거래 금액
//   final String eventType; // 이벤트 유형 (예: 생일, 결혼식 등)
//   final bool isSent; // 보낸 금액 여부
//   final bool? didVisit; // 방문 여부
//   final String? gift; // 선물
//   final String? memo; // 메모
//   final String? contact; // 연락처
//   final PaymentMethod method; // 납부 방법
//   final String? additionalInfo; // 추가 정보

//   PaymentRecord({
//     required this.id,
//     required this.receiverName,
//     required this.date,
//     required this.amount,
//     required this.eventType,
//     required this.isSent,
//     this.didVisit,
//     this.gift,
//     this.memo,
//     this.contact,
//     required this.method,
//     this.additionalInfo, // 선택적 추가 정보
//   });

//   // Getter 추가
//   String get type => isSent ? 'sent' : 'received';

//   // JSON 변환
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'receiverName': receiverName,
//       'date': date.toIso8601String(),
//       'amount': amount,
//       'eventType': eventType,
//       'isSent': isSent,
//       'didVisit': didVisit,
//       'gift': gift,
//       'memo': memo,
//       'contact': contact,
//       'method': method.toString(),
//       'additionalInfo': additionalInfo, // 추가 정보 변환
//     };
//   }

//   // JSON 역변환
//   factory PaymentRecord.fromJson(Map<String, dynamic> json) {
//     return PaymentRecord(
//       id: json['id'],
//       receiverName: json['receiverName'],
//       date: DateTime.parse(json['date']),
//       amount: json['amount'],
//       eventType: json['eventType'],
//       isSent: json['isSent'],
//       didVisit: json['didVisit'],
//       gift: json['gift'],
//       memo: json['memo'],
//       contact: json['contact'],
//       method: PaymentMethod.values
//           .firstWhere((e) => e.toString() == json['method']),
//       additionalInfo: json['additionalInfo'], // 추가 정보 역변환
//     );
//   }

//   // Map<String, dynamic>로 변환 (GiftRecord 호환)
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'amount': amount,
//       'receiverName': receiverName, // GiftRecord의 receiverName 호환
//       'isSent': isSent ? 1 : 0, // Boolean을 정수로 변환
//       'eventType': eventType,
//       'date': date.toIso8601String(), // DateTime을 String으로 변환
//       'didVisit': didVisit,
//       'gift': gift,
//       'memo': memo,
//       'contact': contact,
//       'method': method.toString(),
//       'additionalInfo': additionalInfo, // 추가 정보 변환
//     };
//   }

//   // Map<String, dynamic>로부터 PaymentRecord 객체 생성 (GiftRecord 호환)
//   factory PaymentRecord.fromMap(Map<String, dynamic> map) {
//     return PaymentRecord(
//       id: map['id'],
//       receiverName: map['receiverName'], // GiftRecord의 receiverName 호환
//       amount: map['amount'],
//       isSent: map['isSent'] == 1, // 정수를 Boolean으로 변환
//       eventType: map['eventType'],
//       date: DateTime.parse(map['date']),
//       didVisit: map['didVisit'],
//       gift: map['gift'],
//       memo: map['memo'],
//       contact: map['contact'],
//       method:
//           PaymentMethod.values.firstWhere((e) => e.toString() == map['method']),
//       additionalInfo: map['additionalInfo'], // 추가 정보 역변환
//     );
//   }
// }

// // PaymentMethod Enum
// enum PaymentMethod { bankTransfer, cash, creditCard, other }
