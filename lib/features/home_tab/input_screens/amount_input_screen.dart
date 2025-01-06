import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onjung_v1/data/%08shared/unified_transaction.dart';
import 'package:flutter_onjung_v1/features/home_tab/input_screens/event_type_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransactionsData {
  final String nickname;
  final List<UnifiedTransaction> transactions;

  TransactionsData({
    required this.nickname,
    required this.transactions,
  });

  factory TransactionsData.fromJson(Map<String, dynamic> json) {
    return TransactionsData(
      nickname: json['nickname'] ?? '',
      transactions: (json['transactions'] as List)
          .map((transaction) =>
              UnifiedTransaction.fromJson(transaction as Map<String, dynamic>))
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
  List<UnifiedTransaction> filteredTransactions = [];
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
      debugPrint('Error loading transactions: $e');
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
              (transaction.counterpart ?? '').contains(_nameController.text))
          .where((transaction) =>
              seenCounterparts.add(transaction.counterpart ?? '')) // 중복 제거
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
            if (Navigator.canPop(context)) {
              context.pop(); // GoRouter 뒤로가기
            } else {
              Navigator.pop(context); // 기본 Navigator로 처리
            }
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
                        setState(() {
                          _nameController.text = transaction.counterpart ?? '';
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
                                transaction.counterpart ?? '알 수 없음',
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
                                transaction.relationDetail?.isNotEmpty == true
                                    ? '${transaction.relation ?? ''} • ${transaction.relationDetail}'
                                    : transaction.relation ?? '',
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                DateFormat('yyyy-MM-dd')
                                    .format(transaction.date),
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

  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###원', 'ko_KR');
    return formatter.format(amount);
  }

  Widget _buildChip(String amount) {
    return GestureDetector(
      onTap: () {
        setState(() {
          final currentAmount = int.tryParse(
                _amountController.text.replaceAll(',', '').replaceAll('원', ''),
              ) ??
              0;

          final selectedAmount = int.tryParse(
                amount.replaceAll(RegExp(r'[^0-9]'), ''),
              ) ??
              0;

          final updatedAmount = currentAmount + selectedAmount;

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
