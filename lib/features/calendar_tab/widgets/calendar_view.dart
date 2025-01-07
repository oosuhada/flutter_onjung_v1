import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/screens/transaction_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/calendar_provider.dart';

final calendarProviderProvider =
    ChangeNotifierProvider((ref) => CalendarProvider());

class CalendarView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarProvider = ref.watch(calendarProviderProvider);

    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2025, 12, 31),
      focusedDay: calendarProvider.focusedDay,
      selectedDayPredicate: (day) =>
          isSameDay(calendarProvider.selectedDay, day),
      calendarFormat: calendarProvider.calendarFormat,
      onDaySelected: (selectedDay, focusedDay) {
        ref
            .read(calendarProviderProvider.notifier)
            .onDaySelected(selectedDay, focusedDay);
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
        ref.read(calendarProviderProvider.notifier).onFormatChanged(format);
      },
    );
  }
}
