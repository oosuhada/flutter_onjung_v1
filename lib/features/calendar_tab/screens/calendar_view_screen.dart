import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/%08shared/widgets/custom_date_picker.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/providers/calendar_provider.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/providers/transaction_provider.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/widgets/custom_calendar.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/widgets/monthly_stats_summary.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/widgets/transaction_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // NumberFormat을 사용하기 위해 추가

class CalendarViewScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<CalendarViewScreen> createState() => _CalendarViewScreenState();
}

class _CalendarViewScreenState extends ConsumerState<CalendarViewScreen> {
  final numberFormat = NumberFormat('#,###', 'ko_KR');

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(transactionProvider).initializeTransactions();
      ref.read(calendarProvider).updateEvents(
            ref.read(transactionProvider).transactions,
          );
    });
  }

  Map<DateTime, List<TransactionCount>> _getFormattedTransactionCounts() {
    final localTransactions = ref.read(transactionProvider).transactions;
    final Map<DateTime, List<TransactionCount>> result = {};

    for (final transaction in localTransactions) {
      final date = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );

      if (!result.containsKey(date)) {
        result[date] = [
          TransactionCount('sent', 0),
          TransactionCount('received', 0),
        ];
      }

      if (transaction.type == 'sent') {
        final currentCount = result[date]![0].count;
        result[date]![0] = TransactionCount('sent', currentCount + 1);
      } else {
        final currentCount = result[date]![1].count;
        result[date]![1] = TransactionCount('received', currentCount + 1);
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final localCalendarProvider = ref.watch(calendarProvider);
    final localTransactionProvider = ref.watch(transactionProvider);
    final monthlyStats = localCalendarProvider.getMonthlyStats(); // 월간 통계 가져오기
    final transactionCounts = _getFormattedTransactionCounts();

    return SingleChildScrollView(
      // 스크롤뷰 추가
      child: Column(
        children: [
          // 월 선택 및 분석 버튼
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    // 년/월 선택
                    final selectedDate = await showYearMonthPicker(
                      context,
                      initialYear: localCalendarProvider.focusedDay.year,
                      initialMonth: localCalendarProvider.focusedDay.month,
                    );
                    if (selectedDate != null) {
                      debugPrint(
                          '📅 선택된 년월: ${selectedDate.$1}-${selectedDate.$2}');
                      localCalendarProvider.updateFocusedDay(
                        DateTime(selectedDate.$1, selectedDate.$2),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        '${localCalendarProvider.focusedDay.year}년 ${localCalendarProvider.focusedDay.month}월',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    debugPrint('📊 분석 버튼 클릭됨');
                    debugPrint(
                        '📋 Total transactions: ${localTransactionProvider.transactions.length}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    textStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    fixedSize: const Size(80, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text('분석'),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: MonthlyStatsSummary(
              sentAmount: monthlyStats.sentAmount,
              sentCount: monthlyStats.sentCount,
              receivedAmount: monthlyStats.receivedAmount,
              receivedCount: monthlyStats.receivedCount,
            ),
          ),

          // 달력 - 날짜별 거래 횟수 표시
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomCalendar(
              selectedDay: localCalendarProvider.selectedDay,
              focusedDay: localCalendarProvider.focusedDay,
              transactionCounts: transactionCounts,
              onDaySelected: (selectedDay) {
                localCalendarProvider.onDaySelected(
                  selectedDay,
                  selectedDay,
                );
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => TransactionBottomSheet(
                    selectedDate: selectedDay,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
