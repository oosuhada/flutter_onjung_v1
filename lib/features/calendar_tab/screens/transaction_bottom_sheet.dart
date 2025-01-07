// 1. transaction_bottom_sheet.dart 수정
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/screens/transaction_detail_screen.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/widgets/transaction_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transaction_provider.dart';

class TransactionBottomSheet extends ConsumerWidget {
  final DateTime selectedDate;

  const TransactionBottomSheet({required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions =
        ref.watch(transactionProvider).getTransactionsForDay(selectedDate);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.2,
      maxChildSize: 0.75,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return TransactionItem(
                transaction: transactions[index],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionDetailScreen(
                      transaction: transactions[index],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
