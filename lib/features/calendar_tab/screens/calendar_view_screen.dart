import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/screens/transaction_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/calendar_provider.dart';

// CalendarProvider를 관리하기 위한 Riverpod Provider 선언
final calendarProviderProvider =
    ChangeNotifierProvider((ref) => CalendarProvider());

// CalendarViewScreen 클래스 정의
class CalendarViewScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // CalendarProvider 상태를 구독
    final calendarProvider = ref.watch(calendarProviderProvider);

    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2025, 12, 31),
      focusedDay: calendarProvider.focusedDay,
      selectedDayPredicate: (day) =>
          isSameDay(calendarProvider.selectedDay, day),
      calendarFormat: calendarProvider.calendarFormat,
      onDaySelected: (selectedDay, focusedDay) {
        // 날짜 선택 시 상태 업데이트
        ref
            .read(calendarProviderProvider.notifier)
            .onDaySelected(selectedDay, focusedDay);

        // 선택된 날짜에 해당하는 거래 내역을 표시하는 BottomSheet
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => TransactionBottomSheet(
            selectedDate: selectedDay,
          ),
        );
      },
      onFormatChanged: (format) {
        // 캘린더 형식 변경 시 상태 업데이트
        ref.read(calendarProviderProvider.notifier).onFormatChanged(format);
      },
    );
  }
}
