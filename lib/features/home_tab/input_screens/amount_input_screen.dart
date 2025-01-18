import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onjung_v1/features/home_tab/input_screens/event_type_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// 검색 결과를 위한 데이터 모델
class Transaction {
  final String id;
  final String date;
  final int amount;
  final String type;
  final String counterpart;
  final String relation;
  final String relationDetail;
  final String label;

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.type,
    required this.counterpart,
    required this.relation,
    required this.relationDetail,
    required this.label,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      amount: json['amount'] ?? 0,
      type: json['type'] ?? '',
      counterpart: json['counterpart'] ?? '',
      relation: json['relation'] ?? '',
      relationDetail: json['relation_detail'] ?? '',
      label: json['label'] ?? '',
    );
  }
}

class TransactionsData {
  final String nickname;
  final List<Transaction> transactions;

  TransactionsData({
    required this.nickname,
    required this.transactions,
  });

  factory TransactionsData.fromJson(Map<String, dynamic> json) {
    return TransactionsData(
      nickname: json['nickname'] ?? '',
      transactions: (json['transactions'] as List)
          .map((transaction) => Transaction.fromJson(transaction))
          .toList(),
    );
  }
}

class AmountInputScreen extends StatefulWidget {
  const AmountInputScreen({Key? key}) : super(key: key);

  @override
  State<AmountInputScreen> createState() => _AmountInputScreenState();
}

class _AmountInputScreenState extends State<AmountInputScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  List<Transaction> filteredTransactions = [];
  TransactionsData? transactionsData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTransactions();
    _nameController.addListener(_filterTransactions);
  }

  Future<void> _loadTransactions() async {
    try {
      // JSON 파일 로드
      final String jsonString = await rootBundle
          .loadString('assets/dummy_transactions_personal.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      setState(() {
        transactionsData = TransactionsData.fromJson(jsonData);
      });
    } catch (e) {
      print('Error loading transactions: $e');
    }
  }

  void _filterTransactions() {
    if (_nameController.text.isEmpty || transactionsData == null) {
      setState(() {
        filteredTransactions = [];
      });
      return;
    }

    // 중복 제거를 위한 Set
    final Set<String> seenCounterparts = {};

    setState(() {
      filteredTransactions = transactionsData!.transactions
          .where((transaction) =>
              transaction.counterpart.contains(_nameController.text))
          .where((transaction) =>
              seenCounterparts.add(transaction.counterpart)) // 중복 제거
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date)); // 날짜 기준 내림차순 정렬
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _handleChipPress(String amount) {
    String numericAmount = amount.replaceAll(RegExp(r'[^0-9]'), '');
    int newAmount = int.parse(numericAmount);
    int currentAmount = int.tryParse(_amountController.text) ?? 0;

    _amountController.text = (currentAmount + newAmount).toString();
  }

  void _resetAmount() {
    _amountController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home'); // 홈 화면으로 직접 이동
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '보내요'),
            Tab(text: '받아요'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent(
            context,
            title: '얼마를 보냈나요?',
            hintText: '금액을 입력해주세요',
          ),
          _buildTabContent(
            context,
            title: '얼마를 받았나요?',
            hintText: '금액을 입력해주세요',
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context,
      {required String title, required String hintText}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _resetAmount,
              ),
            ),
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 16),
          _buildAmountChips(),
          const SizedBox(height: 24),
          Text(
            '누구에게 보냈나요?',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: '받는 사람 이름을 입력하세요',
              hintStyle: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 20),
          ),
          if (filteredTransactions.isNotEmpty)
            Expanded(
              child: Card(
                margin: const EdgeInsets.only(top: 4),
                elevation: 4,
                child: ListView.builder(
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = filteredTransactions[index];
                    return InkWell(
                      onTap: () {
                        // counterpart 이름을 TextField에 자동으로 채워줌
                        setState(() {
                          _nameController.text = transaction.counterpart;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2, // 이름이 조금 더 넓게 차지하도록 설정
                              child: Text(
                                transaction.counterpart,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 4, // 최근 거래 정보
                              child: Text(
                                transaction.relationDetail.isNotEmpty
                                    ? ' ${transaction.relation} • ${transaction.relationDetail}  ${transaction.label}'
                                    : ' ${transaction.relation}  ${transaction.label}',
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                ' ${transaction.date}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          if (filteredTransactions.isEmpty) const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventTypeScreen(
                      amount: int.tryParse(_amountController.text) ??
                          0, // 금액 입력값 전달
                      receiverName: _nameController.text, // 이름 입력값 전달
                      isSent: _tabController.index == 0, // 탭 인덱스에 따라 송금 여부 전달
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                '다음',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountChips() {
    // 금액 리스트를 숫자 기반으로 변경 후 포맷팅
    final amounts = [10000, 30000, 50000, 100000, 500000];
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: amounts
                .map((amount) => _buildChip(formatCurrency(amount)))
                .toList(),
          ),
        ),
      ],
    );
  }

// NumberFormat을 사용해 금액을 포맷팅하는 함수
  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###원', 'ko_KR');
    return formatter.format(amount);
  }

// Chip을 생성하는 함수
  Widget _buildChip(String amount) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // TextField의 현재 값 가져오기
          final currentAmount = int.tryParse(
                _amountController.text.replaceAll(',', '').replaceAll('원', ''),
              ) ??
              0;

          // Chip에서 선택된 금액 파싱
          final selectedAmount = int.tryParse(
                amount.replaceAll(RegExp(r'[^0-9]'), ''),
              ) ??
              0;

          // 새로운 값 계산
          final updatedAmount = currentAmount + selectedAmount;

          // TextField의 컨트롤러 업데이트
          _amountController.text = formatCurrency(updatedAmount);
        });
      },
      child: Chip(
        label: Text(
          amount,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[800],
      ),
    );
  }
}
