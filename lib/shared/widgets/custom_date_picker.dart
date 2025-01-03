import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
