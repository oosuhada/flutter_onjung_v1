import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/shared/unified_transaction.dart';

class MemberHistoryListSection extends StatelessWidget {
  final List<UnifiedTransaction> records;
  final DateTime startDate;
  final DateTime endDate;

  const MemberHistoryListSection({
    Key? key,
    required this.records,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 날짜 범위 내의 기록만 필터링
    final filteredRecords = records.where((record) {
      return record.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          record.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    // 날짜별로 그룹화
    Map<String, List<UnifiedTransaction>> groupedRecords = {};
    for (var record in filteredRecords) {
      String dateKey = _formatDateKey(record.date);
      if (!groupedRecords.containsKey(dateKey)) {
        groupedRecords[dateKey] = [];
      }
      groupedRecords[dateKey]!.add(record);
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedRecords.length,
      itemBuilder: (context, index) {
        String dateKey = groupedRecords.keys.elementAt(index);
        List<UnifiedTransaction> dayRecords = groupedRecords[dateKey]!;

        // 일별 총액 계산
        int sentTotal = dayRecords
            .where((r) => r.type == 'sent')
            .fold(0, (sum, r) => sum + r.amount);
        int receivedTotal = dayRecords
            .where((r) => r.type == 'received')
            .fold(0, (sum, r) => sum + r.amount);

        return Column(
          children: [
            _buildDateHeader(dateKey, sentTotal, receivedTotal),
            ...dayRecords.map((record) => _buildTransactionItem(record)),
            const Divider(height: 1),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(String date, int sentTotal, int receivedTotal) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            '${_formatAmount(sentTotal)} / ${_formatAmount(receivedTotal)}',
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(UnifiedTransaction record) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(_getIconForEvent(record.label), color: Colors.black),
      ),
      title: Text('${record.label} | ${_getPaymentMethod(record)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_formatAmount(record.amount)}원',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            record.type == 'sent' ? Icons.arrow_forward : Icons.arrow_back,
            size: 16,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  String _formatDateKey(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return "${date.month}월 ${date.day}일 (${_getWeekday(date)}) 오늘";
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return "${date.month}월 ${date.day}일 (${_getWeekday(date)}) 어제";
    } else {
      return "${date.month}월 ${date.day}일 (${_getWeekday(date)})";
    }
  }

  String _getWeekday(DateTime date) {
    const weekdays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    return weekdays[date.weekday - 1];
  }

  String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  IconData _getIconForEvent(String eventType) {
    switch (eventType.toLowerCase()) {
      case '생일':
        return Icons.card_giftcard;
      case '결혼식':
        return Icons.person;
      case '장례식':
        return Icons.favorite;
      case '돌잔치':
        return Icons.child_care;
      default:
        return Icons.event;
    }
  }

  String _getPaymentMethod(UnifiedTransaction record) {
    return record.method.toReadableString();
  }
}
