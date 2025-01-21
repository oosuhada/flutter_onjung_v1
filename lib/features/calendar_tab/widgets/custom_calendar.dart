import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final Function(DateTime selectedDay)? onDaySelected;
  final Map<DateTime, List<TransactionCount>> transactionCounts;

  const CustomCalendar({
    super.key,
    this.selectedDay,
    required this.focusedDay,
    this.onDaySelected,
    required this.transactionCounts,
  });

  @override
  CustomCalendarState createState() => CustomCalendarState();
}

class CustomCalendarState extends State<CustomCalendar> {
  late DateTime _startOfMonth;
  late DateTime _endOfMonth;
  final DateFormat _dayFormat = DateFormat('d');

  @override
  void initState() {
    super.initState();
    _updateMonth(widget.focusedDay);
  }

  @override
  void didUpdateWidget(CustomCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusedDay != oldWidget.focusedDay) {
      _updateMonth(widget.focusedDay);
    }
  }

  void _updateMonth(DateTime date) {
    _startOfMonth = DateTime(date.year, date.month, 1);
    _endOfMonth = DateTime(date.year, date.month + 1, 0);
  }

  List<TransactionCount> _getTransactionsForDay(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return widget.transactionCounts[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfWeek = _startOfMonth.weekday % 7;
    final totalDays = _endOfMonth.day;
    final totalCells = firstDayOfWeek + totalDays;
    final weeks = (totalCells / 7).ceil();

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 요일 헤더
          SizedBox(
            height: 40,
            child: Row(
              children: ['일', '월', '화', '수', '목', '금', '토'].map((day) {
                final color = day == '일'
                    ? Colors.red
                    : day == '토'
                        ? Colors.blue
                        : Colors.grey;
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(color: color),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // 날짜 그리드
          GridView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.8,
            ),
            itemCount: weeks * 7,
            itemBuilder: (context, index) {
              final dayIndex = index - firstDayOfWeek;
              DateTime? displayDate;

              if (dayIndex < 0) {
                // 이전 달의 날짜 계산
                displayDate = _startOfMonth
                    .subtract(Duration(days: firstDayOfWeek - index));
              } else if (dayIndex >= totalDays) {
                // 다음 달의 날짜 계산
                displayDate =
                    _endOfMonth.add(Duration(days: dayIndex - totalDays + 1));
              } else {
                // 현재 달의 날짜 계산
                displayDate = DateTime(
                  widget.focusedDay.year,
                  widget.focusedDay.month,
                  dayIndex + 1,
                );
              }

              final isValidDay = dayIndex >= 0 && dayIndex < totalDays;
              final weekday = index % 7;
              final color = (weekday == 0
                  ? Colors.red
                  : weekday == 6
                      ? Colors.blue
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black);

              final transactions = _getTransactionsForDay(displayDate);
              final sentCount = transactions
                  .firstWhere(
                    (t) => t.type == 'sent',
                    orElse: () => TransactionCount('sent', 0),
                  )
                  .count;
              final receivedCount = transactions
                  .firstWhere(
                    (t) => t.type == 'received',
                    orElse: () => TransactionCount('received', 0),
                  )
                  .count;

              return InkWell(
                onTap: () {
                  if (widget.onDaySelected != null && isValidDay) {
                    widget.onDaySelected!(displayDate!);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _dayFormat.format(displayDate),
                        style: TextStyle(
                          color: isValidDay ? color : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (sentCount > 0)
                        Text(
                          '보냄 ${sentCount}회',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            height: 1.2,
                          ),
                        ),
                      if (receivedCount > 0)
                        Text(
                          '받음 ${receivedCount}회',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            height: 1.2,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// 거래 횟수를 저장하는 모델 클래스
class TransactionCount {
  final String type;
  final int count;

  TransactionCount(this.type, this.count);
}
