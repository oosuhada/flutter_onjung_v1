import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/services/database_provider.dart';
import 'package:flutter_onjung_v1/data/shared/unified_transaction.dart';
import 'package:flutter_onjung_v1/features/home_tab/input_screens/date_selection_screen.dart';
import 'package:go_router/go_router.dart';

class EventTypeScreen extends StatefulWidget {
  final int amount;
  final String receiverName;
  final bool isSent;

  const EventTypeScreen({
    Key? key,
    required this.amount,
    required this.receiverName,
    required this.isSent,
  }) : super(key: key);

  @override
  State<EventTypeScreen> createState() => _EventTypeScreenState();
}

class _EventTypeScreenState extends State<EventTypeScreen> {
  String? selectedEvent;
  DateTime selectedDate = DateTime.now();
  final TextEditingController _customEventController = TextEditingController();
  bool showDateSection = false;

  final List<String> eventTypes = [
    '결혼식',
    '돌잔치',
    '장례식',
    '생일 기념일',
    '명절',
    '개업',
    '직접 입력',
    '나중에 입력',
  ];

  @override
  void dispose() {
    _customEventController.dispose();
    super.dispose();
  }

  void _handleEventSelection(String event) {
    setState(() {
      if (selectedEvent == event) {
        selectedEvent = null;
        showDateSection = false;
      } else {
        selectedEvent = event;
        showDateSection = true;
      }
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  Future<void> _handleSave(BuildContext context) async {
    debugPrint('저장 버튼 클릭됨');

    if (selectedEvent == null) {
      debugPrint('선택된 이벤트가 없음');
      return;
    }

    // ID 생성 (예: UUID 또는 특정 규칙에 따라 생성)
    final String recordId =
        DateTime.now().millisecondsSinceEpoch.toString(); // 임시 ID 생성 방식
    final PaymentMethod method =
        PaymentMethod.cash; // 사용 가능한 결제 수단으로 설정 (예: cash)

    final transaction = UnifiedTransaction(
      id: recordId,
      type: widget.isSent ? 'sent' : 'received',
      date: selectedDate,
      label: selectedEvent!,
      amount: widget.amount,
      method: method,
      counterpart: widget.receiverName,
      relation: null, // 관계 정보 추가 가능
      relationDetail: null, // 관계 상세 정보 추가 가능
      memberInfo: null, // 관련된 멤버 데이터
      scheduleInfo: null, // 스케줄 데이터 추가 가능
      activityInfo: null, // 활동 데이터 추가 가능
    );

    try {
      debugPrint('저장 작업 시작');
      final db = await DatabaseProvider.instance.database;
      debugPrint('데이터베이스 연결 성공');

      final transactionMap = transaction.toJson(); // 변수 이름 수정
      debugPrint('저장할 데이터: $transactionMap');

      await db.insertRecord(transactionMap); // `record`를 `transactionMap`으로 수정
      debugPrint('DB에 데이터 저장 성공');

      if (!mounted) {
        debugPrint('위젯이 더 이상 마운트되지 않음');
        return;
      }

      debugPrint('메인 화면으로 이동 시도');
      if (context.mounted) {
        context.go('/home'); // 홈 화면으로 직접 이동
        debugPrint('메인 화면으로 이동 완료 (popUntil)');
      } else {
        debugPrint('context가 더 이상 유효하지 않음');
      }
    } catch (e, stacktrace) {
      debugPrint('DB 저장 또는 라우팅 중 오류 발생: $e');
      debugPrint('스택트레이스: $stacktrace');

      if (!mounted) {
        debugPrint('오류 발생 시 위젯이 마운트되지 않음');
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 중 오류가 발생했습니다: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '어떤 경조사였나요?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (selectedEvent == '직접 입력') ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: _customEventController,
                        decoration: const InputDecoration(
                          hintText: '어떤 경조사였나요?',
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: selectedEvent == null
                        ? eventTypes.map((event) => _buildChip(event)).toList()
                        : [_buildChip(selectedEvent!)],
                  ),
                  if (showDateSection) ...[
                    const SizedBox(height: 36),
                    DateSelectionSection(
                      amount: widget.amount,
                      receiverName: widget.receiverName,
                      isSent: widget.isSent,
                      eventType: selectedEvent ?? '',
                      initialDate: selectedDate,
                      onDateSelected: _onDateSelected,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (showDateSection)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      selectedEvent == null ? null : () => _handleSave(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    '저장',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChip(String eventName) {
    return GestureDetector(
      onTap: () => _handleEventSelection(eventName),
      child: Chip(
        label: Text(
          eventName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[800],
      ),
    );
  }
}
