import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // NumberFormat을 사용하기 위해 추가

class MonthlyStatsSummary extends StatelessWidget {
  final int sentAmount;
  final int sentCount;
  final int receivedAmount;
  final int receivedCount;

  MonthlyStatsSummary({
    required this.sentAmount,
    required this.sentCount,
    required this.receivedAmount,
    required this.receivedCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###', 'ko_KR');

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('보냄',
                  style: Theme.of(context).textTheme.titleMedium), // 제목 스타일
              const SizedBox(width: 12),
              Text(
                '${numberFormat.format(sentAmount)}원 / ${sentCount}회',
                style: Theme.of(context).textTheme.bodyLarge, // 내용 스타일
              ),
            ],
          ),
          const SizedBox(height: 16), // 간격
          Row(
            children: [
              Text('받음', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(width: 12),
              Text(
                '${numberFormat.format(receivedAmount)}원 / ${receivedCount}회',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
