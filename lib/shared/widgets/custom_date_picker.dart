import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime selectedDate = DateTime.now();

  Future<DateTime?> showCustomDatePicker(
    BuildContext context, {
    required DateTime initialDate,
  }) async {
    final currentYear = DateTime.now().year;
    final years = List.generate(10, (index) => currentYear - index);
    DateTime tempDate = initialDate;

    final result = await showModalBottomSheet<DateTime?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return CupertinoTheme(
          data: CupertinoTheme.of(context),
          child: Container(
            height: 300,
            padding: const EdgeInsets.only(top: 6.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text('취소'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                      child: const Text('확인'),
                      onPressed: () => Navigator.of(context).pop(tempDate),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    children: [
                      // Year Picker
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 38,
                          scrollController: FixedExtentScrollController(
                            initialItem: years.indexOf(initialDate.year),
                          ),
                          onSelectedItemChanged: (int index) {
                            tempDate = DateTime(
                              years[index],
                              tempDate.month,
                              tempDate.day,
                            );
                          },
                          children: years.map((year) {
                            return Center(
                              child: Text(
                                '$year년',
                                style: const TextStyle(
                                  fontSize: 21,
                                  color: CupertinoColors.label,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      // Month Picker
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 38,
                          scrollController: FixedExtentScrollController(
                            initialItem: initialDate.month - 1,
                          ),
                          onSelectedItemChanged: (int index) {
                            tempDate = DateTime(
                              tempDate.year,
                              index + 1,
                              tempDate.day,
                            );
                          },
                          children: List<Widget>.generate(12, (index) {
                            return Center(
                              child: Text(
                                '${index + 1}월',
                                style: const TextStyle(
                                  fontSize: 21,
                                  color: CupertinoColors.label,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      // Day Picker
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 38,
                          scrollController: FixedExtentScrollController(
                            initialItem: initialDate.day - 1,
                          ),
                          onSelectedItemChanged: (int index) {
                            final daysInMonth = DateTime(
                              tempDate.year,
                              tempDate.month + 1,
                              0,
                            ).day;
                            tempDate = DateTime(
                              tempDate.year,
                              tempDate.month,
                              (index + 1) > daysInMonth
                                  ? daysInMonth
                                  : (index + 1),
                            );
                          },
                          children: List<Widget>.generate(31, (index) {
                            return Center(
                              child: Text(
                                '${index + 1}일',
                                style: const TextStyle(
                                  fontSize: 21,
                                  color: CupertinoColors.label,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            final date = await showCustomDatePicker(
              context,
              initialDate: selectedDate,
            );
            if (date != null) {
              setState(() {
                selectedDate = date;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future<(int, int)?> showYearMonthPicker(
  BuildContext context, {
  required int initialYear,
  required int initialMonth,
}) async {
  int selectedYear = initialYear;
  int selectedMonth = initialMonth;
  final currentYear = DateTime.now().year;
  final years = List.generate(10, (index) => currentYear - index);

  final result = await showModalBottomSheet<(int, int)?>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return CupertinoTheme(
        data: CupertinoTheme.of(context), // 시스템 테마를 그대로 사용
        child: Container(
          height: 300,
          padding: const EdgeInsets.only(top: 6.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('취소'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: const Text('확인'),
                    onPressed: () => Navigator.of(context)
                        .pop((selectedYear, selectedMonth)),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 38,
                        scrollController: FixedExtentScrollController(
                          initialItem: years.indexOf(initialYear),
                        ),
                        onSelectedItemChanged: (int index) {
                          selectedYear = years[index];
                        },
                        children: years.map((year) {
                          return Center(
                            child: Text(
                              '$year년',
                              style: TextStyle(
                                fontSize: 21,
                                color: CupertinoColors.label,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 38,
                        scrollController: FixedExtentScrollController(
                          initialItem: initialMonth - 1,
                        ),
                        onSelectedItemChanged: (int index) {
                          selectedMonth = index + 1;
                        },
                        children: List<Widget>.generate(12, (index) {
                          return Center(
                            child: Text(
                              '${index + 1}월',
                              style: TextStyle(
                                fontSize: 21,
                                color: CupertinoColors.label,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  return result;
}
