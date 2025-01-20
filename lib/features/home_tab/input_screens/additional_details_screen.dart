import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/services/database_provider.dart';
import 'package:flutter_onjung_v1/data/shared/unified_transaction.dart';

class AdditionalDetailsScreen extends StatefulWidget {
  final int amount; // 금액
  final String receiverName; // 수신인 이름
  final bool isSent; // 발송 여부
  final String eventType; // 이벤트 유형
  final DateTime date; // 날짜

  const AdditionalDetailsScreen({
    Key? key,
    required this.amount,
    required this.receiverName,
    required this.isSent,
    required this.eventType,
    required this.date,
  }) : super(key: key);

  @override
  State<AdditionalDetailsScreen> createState() =>
      _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {
  bool didVisit = false; // 방문 여부
  final TextEditingController giftController = TextEditingController();
  final TextEditingController memoController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  @override
  void dispose() {
    // 컨트롤러 해제
    giftController.dispose();
    memoController.dispose();
    contactController.dispose();
    super.dispose();
  }

  Future<void> _saveRecord() async {
    // ID 생성
    final String recordId = DateTime.now().millisecondsSinceEpoch.toString();
    final PaymentMethod method = PaymentMethod.cash;

    // UnifiedTransaction 생성
    final transaction = UnifiedTransaction(
      id: recordId,
      type: widget.isSent ? 'sent' : 'received',
      date: widget.date,
      label: widget.eventType,
      amount: widget.amount,
      method: method,
      counterpart: widget.receiverName,
      relation: null,
      relationDetail: null,
      memberInfo: null,
      scheduleInfo: null,
      activityInfo: null,
    );

    try {
      // 데이터베이스에 삽입
      final db = await DatabaseProvider.instance.database;
      await db.insertRecord(transaction.toJson()); // toJson()을 사용해 삽입

      // 저장 후 이전 화면으로 이동
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장 중 오류가 발생했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('추가 정보'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '방문 여부',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Switch(
                value: didVisit,
                onChanged: (value) {
                  setState(() {
                    didVisit = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              _buildTextField(
                label: '선물',
                controller: giftController,
                hint: '어떤 선물을 하셨나요?',
              ),
              const SizedBox(height: 24),
              _buildTextField(
                label: '메모',
                controller: memoController,
                hint: '추가로 기록하고 싶은 내용이 있나요?',
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              _buildTextField(
                label: '받은 이의 연락처',
                controller: contactController,
                hint: '연락처를 입력해주세요',
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _saveRecord, // 저장 동작 연결
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
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const UnderlineInputBorder(),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          keyboardType: keyboardType,
          maxLines: maxLines,
        ),
      ],
    );
  }
}

// 데이터베이스 관련 GiftRecord와 DatabaseHelper 클래스는 별도로 구현되어야 합니다.
// 위 코드는 호출 및 데이터 저장 로직만 포함하고 있습니다.
