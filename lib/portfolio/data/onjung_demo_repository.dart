class OnjungRecord {
  const OnjungRecord({
    required this.id,
    required this.person,
    required this.relation,
    required this.event,
    required this.date,
    required this.amount,
    required this.isSent,
    required this.note,
    this.assetPath,
  });

  final String id;
  final String person;
  final String relation;
  final String event;
  final DateTime date;
  final int amount;
  final bool isSent;
  final String note;
  final String? assetPath;
}

class UpcomingEvent {
  const UpcomingEvent({
    required this.title,
    required this.host,
    required this.date,
    required this.location,
    required this.assetPath,
    required this.relation,
  });

  final String title;
  final String host;
  final DateTime date;
  final String location;
  final String assetPath;
  final String relation;
}

class OnjungDemoRepository {
  const OnjungDemoRepository();

  List<OnjungRecord> get initialRecords => [
        OnjungRecord(
          id: 'r1',
          person: '김서연',
          relation: '대학 친구',
          event: '결혼식',
          date: DateTime(2026, 8, 16),
          amount: 100000,
          isSent: true,
          note: '직접 참석해서 축하. 식사는 함께하지 못함.',
          assetPath: 'assets/wedding_hall.png',
        ),
        OnjungRecord(
          id: 'r2',
          person: '박준호',
          relation: '회사 동료',
          event: '부친상',
          date: DateTime(2026, 8, 10),
          amount: 100000,
          isSent: true,
          note: '장례식장 방문, 계좌이체로 조의금 전달.',
          assetPath: 'assets/funeral_hall.png',
        ),
        OnjungRecord(
          id: 'r3',
          person: '이도윤',
          relation: '고등학교 친구',
          event: '돌잔치',
          date: DateTime(2026, 8, 3),
          amount: 70000,
          isSent: false,
          note: '지난 돌잔치 때 받은 금액. 다음 경조사 때 참고.',
        ),
        OnjungRecord(
          id: 'r4',
          person: '최지민',
          relation: '사촌',
          event: '결혼식',
          date: DateTime(2026, 7, 19),
          amount: 200000,
          isSent: false,
          note: '가족 단위 참석. 부모님 기록과 함께 확인.',
          assetPath: 'assets/wedding_hall.png',
        ),
        OnjungRecord(
          id: 'r5',
          person: '정하늘',
          relation: '프로젝트 동료',
          event: '개업',
          date: DateTime(2026, 7, 4),
          amount: 50000,
          isSent: true,
          note: '오픈 당일 화분 대신 축하금 전달.',
        ),
      ];

  List<UpcomingEvent> get upcomingEvents => [
        UpcomingEvent(
          title: '민수 · 예은 결혼식',
          host: '김민수',
          date: DateTime(2026, 8, 29, 13, 30),
          location: '서울 강남 · 더채플',
          assetPath: 'assets/wedding_hall.png',
          relation: '대학 동기',
        ),
        UpcomingEvent(
          title: '현우 아버님 장례',
          host: '조현우',
          date: DateTime(2026, 9, 3, 18),
          location: '서울 송파 · 아산병원 장례식장',
          assetPath: 'assets/funeral_hall.png',
          relation: '전 직장 동료',
        ),
      ];
}
