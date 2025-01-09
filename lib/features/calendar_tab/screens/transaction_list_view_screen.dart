import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/shared/unified_transaction.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/providers/transaction_provider.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/screens/transaction_detail_screen.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/widgets/monthly_stats_summary.dart';
import 'package:flutter_onjung_v1/shared/widgets/custom_date_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

enum SortOrder { newest, oldest }

class TransactionListViewScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<TransactionListViewScreen> createState() =>
      _TransactionListViewScreenState();
}

class _TransactionListViewScreenState
    extends ConsumerState<TransactionListViewScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  SortOrder _currentSortOrder = SortOrder.newest;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year - 1, now.month);
    _endDate = DateTime(now.year, now.month);
  }

  Map<String, int> calculatePeriodStats(List<UnifiedTransaction> transactions) {
    final stats = {
      'sentAmount': 0,
      'sentCount': 0,
      'receivedAmount': 0,
      'receivedCount': 0,
    };

    for (var transaction in transactions) {
      if (transaction.type == 'sent') {
        stats['sentAmount'] = (stats['sentAmount'] ?? 0) + transaction.amount;
        stats['sentCount'] = (stats['sentCount'] ?? 0) + 1;
      } else if (transaction.type == 'received') {
        stats['receivedAmount'] =
            (stats['receivedAmount'] ?? 0) + transaction.amount;
        stats['receivedCount'] = (stats['receivedCount'] ?? 0) + 1;
      }
    }

    return stats;
  }

  Widget _buildPeriodStatsHeader(List<UnifiedTransaction> transactions) {
    final stats = calculatePeriodStats(transactions);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '${_startDate?.year}년 ${_startDate?.month}월 ~ ${_endDate?.year}년 ${_endDate?.month}월 통계',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        MonthlyStatsSummary(
          sentAmount: stats['sentAmount'] ?? 0,
          sentCount: stats['sentCount'] ?? 0,
          receivedAmount: stats['receivedAmount'] ?? 0,
          receivedCount: stats['receivedCount'] ?? 0,
        ),
        const Divider(thickness: 2),
      ],
    );
  }

  String _formatAmount(int amount) {
    final formatter = NumberFormat('###,###', 'ko_KR');
    return '${formatter.format(amount)}원';
  }

  String _formatDate(DateTime date) {
    final weekDays = ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'];
    return '${date.day}일 ${weekDays[date.weekday % 7]}';
  }

  Widget _buildTransactionItem(UnifiedTransaction transaction) {
    String relationText = '';
    if (transaction.relationDetail != null) {
      relationText = ' | ${transaction.relationDetail}';
    }

    IconData getIconForTransaction() {
      if (transaction.label.contains('생일')) return Icons.cake;
      if (transaction.label.contains('결혼')) return Icons.favorite;
      if (transaction.label.contains('장례')) return Icons.volunteer_activism;
      return Icons.person;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(
          getIconForTransaction(),
          color: Colors.grey[600],
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            transaction.counterpart ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (transaction.relation != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                transaction.relation!,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
      subtitle: Row(
        children: [
          Text(transaction.label),
          if (transaction.method != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                transaction.method.name,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatAmount(transaction.amount),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (transaction.type == 'received')
            Icon(
              Icons.arrow_forward,
              size: 16,
              color: Colors.grey[400],
            ),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TransactionDetailScreen(transaction: transaction),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final dropdownStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );

    Widget buildDateButton({
      required DateTime? date,
      required VoidCallback onPressed,
    }) {
      return TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              date == null ? '연도-월▼' : '${date.year}년 ${date.month}월▼',
              style: dropdownStyle.copyWith(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.black54),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildDateButton(
          date: _startDate,
          onPressed: () async {
            final result = await showYearMonthPicker(
              context,
              initialYear: _startDate?.year ?? DateTime.now().year,
              initialMonth: _startDate?.month ?? DateTime.now().month,
            );
            if (result != null) {
              setState(() {
                _startDate = DateTime(result.$1, result.$2);
              });
            }
          },
        ),
        Text(
          '부터',
          style: dropdownStyle.copyWith(color: Colors.grey),
        ),
        buildDateButton(
          date: _endDate,
          onPressed: () async {
            final result = await showYearMonthPicker(
              context,
              initialYear: _endDate?.year ?? DateTime.now().year,
              initialMonth: _endDate?.month ?? DateTime.now().month,
            );
            if (result != null) {
              setState(() {
                _endDate = DateTime(result.$1, result.$2);
              });
            }
          },
        ),
        Text(
          '까지',
          style: dropdownStyle.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider).transactions;
    final filteredTransactions = _filterTransactionsByDate(transactions);
    final groupedTransactions = groupTransactionsByDate(filteredTransactions);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: _buildPeriodSelector(),
        ),
        _buildPeriodStatsHeader(filteredTransactions),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () =>
                  setState(() => _currentSortOrder = SortOrder.newest),
              icon: const Icon(Icons.arrow_upward, size: 20),
              label: Text(
                '최신순',
                style: TextStyle(
                  fontWeight: _currentSortOrder == SortOrder.newest
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () =>
                  setState(() => _currentSortOrder = SortOrder.oldest),
              icon: const Icon(Icons.arrow_downward, size: 20),
              label: Text(
                '오래된순',
                style: TextStyle(
                  fontWeight: _currentSortOrder == SortOrder.oldest
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: groupedTransactions.length,
            itemBuilder: (context, index) {
              final entry = groupedTransactions.entries.elementAt(index);
              final date = entry.key;
              final dailyTransactions = entry.value;

              final monthlyStats = calculateDailyTotal(
                groupedTransactions.entries
                    .where((e) =>
                        e.key.year == date.year && e.key.month == date.month)
                    .expand((e) => e.value)
                    .toList(),
              );

              final showMonthHeader = index == 0 ||
                  date.month !=
                      groupedTransactions.entries
                          .elementAt(index - 1)
                          .key
                          .month;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showMonthHeader) ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '${date.year}년 ${date.month}월',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    MonthlyStatsSummary(
                      sentAmount: monthlyStats['sentAmount']!,
                      sentCount: monthlyStats['sentCount']!,
                      receivedAmount: monthlyStats['receivedAmount']!,
                      receivedCount: monthlyStats['receivedCount']!,
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _formatDate(date),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ...dailyTransactions
                      .map((transaction) => _buildTransactionItem(transaction)),
                  const Divider(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Map<String, int> calculateDailyTotal(List<UnifiedTransaction> transactions) {
    return {
      'sentAmount': transactions
          .where((t) => t.type == 'sent')
          .fold(0, (sum, t) => sum + t.amount),
      'sentCount': transactions.where((t) => t.type == 'sent').length,
      'receivedAmount': transactions
          .where((t) => t.type == 'received')
          .fold(0, (sum, t) => sum + t.amount),
      'receivedCount': transactions.where((t) => t.type == 'received').length,
    };
  }

  List<UnifiedTransaction> _filterTransactionsByDate(
      List<UnifiedTransaction> transactions) {
    if (_startDate == null || _endDate == null) return transactions;
    return transactions.where((transaction) {
      final date = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      return date.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
          date.isBefore(_endDate!.add(const Duration(days: 1)));
    }).toList();
  }

  Map<DateTime, List<UnifiedTransaction>> groupTransactionsByDate(
      List<UnifiedTransaction> transactions) {
    final grouped = <DateTime, List<UnifiedTransaction>>{};
    for (var transaction in transactions) {
      final date = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(transaction);
    }
    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) => _currentSortOrder == SortOrder.newest
          ? b.key.compareTo(a.key)
          : a.key.compareTo(b.key));
    return Map.fromEntries(sortedEntries);
  }
}
