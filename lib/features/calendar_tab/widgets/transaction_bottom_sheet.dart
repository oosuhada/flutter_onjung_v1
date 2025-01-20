import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/%08shared/unified_transaction.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/screens/transaction_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // NumberFormat 사용

import '../providers/transaction_provider.dart';

class TransactionBottomSheet extends ConsumerWidget {
  final DateTime selectedDate;

  const TransactionBottomSheet({
    required this.selectedDate,
    Key? key,
  }) : super(key: key);

  // 날짜 포맷
  String _formatDate(DateTime date) {
    final weekDays = ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'];
    return '${date.month}월 ${weekDays[date.weekday % 7]}';
  }

  // 금액 포맷
  String _formatAmount(int amount) {
    final formatter = NumberFormat('#,###', 'ko_KR');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions =
        ref.watch(transactionProvider).getTransactionsForDay(selectedDate);

    final sentTotal = transactions
        .where((t) => t.type == 'sent')
        .fold(0, (sum, t) => sum + t.amount);
    final receivedTotal = transactions
        .where((t) => t.type == 'received')
        .fold(0, (sum, t) => sum + t.amount);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // 헤더 섹션
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 날짜 표시
                    Text(
                      _formatDate(selectedDate),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    // 총계 표시
                    Text(
                      '총 ${transactions.length}건   보냄 ${_formatAmount(sentTotal)}원 / 받음 ${_formatAmount(receivedTotal)}원',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              // 거래 목록
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Icon(
                          Icons.cake, // 거래 타입에 따라 아이콘 변경 가능
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      title: Text(
                        transaction.counterpart ?? '알 수 없음',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        '${transaction.label} | ${transaction.method.toReadableString()}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                      trailing: Text(
                        '${_formatAmount(transaction.amount)}원',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionDetailScreen(
                            transaction: transaction,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
