import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/home_tab/input_screens/additional_details_screen.dart';

// Date Selection Section Widget

class DateSelectionSection extends StatefulWidget {
  final int amount;
  final String receiverName;
  final bool isSent;
  final String eventType;
  final DateTime initialDate; // 추가된 initialDate 파라미터
  final Function(DateTime) onDateSelected; // 선택된 날짜를 상위로 전달하는 콜백

  const DateSelectionSection({
    super.key,
    required this.amount,
    required this.receiverName,
    required this.isSent,
    required this.eventType,
    required this.initialDate, // 필수 파라미터로 추가
    required this.onDateSelected, // 콜백 추가
  });

  @override
  State<DateSelectionSection> createState() => _DateSelectionSectionState();
}

class _DateSelectionSectionState extends State<DateSelectionSection> {
  late DateTime selectedDate; // late로 선언

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate; // 초기값을 widget.initialDate로 설정
  }

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

  void _navigateToAdditionalDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdditionalDetailsScreen(
          amount: widget.amount,
          receiverName: widget.receiverName,
          isSent: widget.isSent,
          eventType: widget.eventType,
          date: selectedDate, // 선택된 날짜 전달
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '${widget.receiverName}님에게 언제 보냈나요?', // receiverName 사용
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
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
              widget.onDateSelected(selectedDate); // 상위로 선택된 날짜 전달
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
        const SizedBox(height: 36),
        const Text(
          '추가로 기록할 내용이 있나요?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '나중에 수정하기를 통해 기록하실 수도 있어요',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 21),
        InkWell(
          onTap: _navigateToAdditionalDetails,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                Chip(
                  label: const Text(
                    '방문 여부',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Chip(
                  label: const Text(
                    '선물',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Chip(
                  label: const Text(
                    '메모',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Chip(
                  label: const Text(
                    '받은 이의 연락처',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
