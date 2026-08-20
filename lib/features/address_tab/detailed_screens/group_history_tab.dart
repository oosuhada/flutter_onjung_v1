import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/address_tab/detailed_screens/member_history_tab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupHistoryTab extends ConsumerWidget {
  final String groupId;

  const GroupHistoryTab({Key? key, required this.groupId}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Group 데이터 가져오기
    final group = ref
        .watch(addressBookProvider)
        .groups
        .firstWhere((group) => group.groupId == groupId);

    // 거래 내역이 없는 경우 처리
    if (group.recentGroupTransactions.isEmpty) {
      return const Center(
        child: Text('거래 내역이 없습니다.'),
      );
    }

    return ListView.separated(
      itemCount: group.recentGroupTransactions.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final transaction = group.recentGroupTransactions[index];

        // 거래 목적 변환 (목적이 없을 경우 "알 수 없음" 표시)
        final purpose = transaction.groupTransactionEventType.isNotEmpty
            ? transaction.groupTransactionEventType
            : "알 수 없음";

        // 표시할 텍스트
        final transactionText =
            '${transaction.groupTransactionAmount}원 - $purpose (${transaction.groupTransactionIsReceived ? "받음" : "보냄"})';

        return ListTile(
          title: Text(transactionText),
          subtitle: Text('날짜: ${transaction.groupTransactionDate.toLocal()}'),
          leading: const Icon(Icons.monetization_on),
        );
      },
    );
  }
}
