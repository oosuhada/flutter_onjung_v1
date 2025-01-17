import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/%08shared/widgets/custom_date_picker.dart';
import 'package:flutter_onjung_v1/data/statistics_models.dart';

class RecentStatisticsSummary extends StatefulWidget {
  final StatisticsSummary statistics;
  final Function(PeriodRange)? onPeriodChanged;

  const RecentStatisticsSummary({
    Key? key,
    required this.statistics,
    this.onPeriodChanged,
  }) : super(key: key);

  @override
  State<RecentStatisticsSummary> createState() =>
      _RecentStatisticsSummaryState();
}

class _RecentStatisticsSummaryState extends State<RecentStatisticsSummary> {
  late int startYear;
  late int startMonth;
  late int endYear;
  late int endMonth;

  @override
  void initState() {
    super.initState();
    startYear = widget.statistics.period.startYear;
    startMonth = widget.statistics.period.startMonth;
    endYear = widget.statistics.period.endYear;
    endMonth = widget.statistics.period.endMonth;
    debugPrint('Initial Period: $startYear/$startMonth ~ $endYear/$endMonth');
  }

  Widget _buildPeriodSelector() {
    final dropdownStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );

    Widget buildDateButton({
      required int year,
      required int month,
      required VoidCallback onPressed,
    }) {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$year년 $month월',
              style: dropdownStyle.copyWith(fontSize: 19.0),
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
          year: startYear,
          month: startMonth,
          onPressed: () async {
            final result = await showYearMonthPicker(
              context,
              initialYear: startYear,
              initialMonth: startMonth,
            );
            if (result != null) {
              setState(() {
                startYear = result.$1;
                startMonth = result.$2;
                _updatePeriod();
              });
            }
          },
        ),
        Text('부터  ', style: dropdownStyle),
        buildDateButton(
          year: endYear,
          month: endMonth,
          onPressed: () async {
            final result = await showYearMonthPicker(
              context,
              initialYear: endYear,
              initialMonth: endMonth,
            );
            if (result != null) {
              setState(() {
                endYear = result.$1;
                endMonth = result.$2;
                _updatePeriod();
              });
            }
          },
        ),
        Text(' 까지', style: dropdownStyle),
      ],
    );
  }

  void _updatePeriod() {
    final newPeriod = PeriodRange(
      startYear: startYear,
      startMonth: startMonth,
      endYear: endYear,
      endMonth: endMonth,
    );
    debugPrint('Period changed: $newPeriod');
    widget.onPeriodChanged?.call(newPeriod);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${widget.statistics.nickname}님',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  ' 은  ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                // const Text(
                //   '총 ',
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: Colors.black87,
                //   ),
                // ),
                Text(
                  '${widget.statistics.totalCount}명',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  ' 과',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 0.0),
            _buildPeriodSelector(),
            const SizedBox(height: 0.0),
            const Text(
              '이렇게 온정을 나눴어요',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        '총 ${widget.statistics.totalCount}회',
                        style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '(보냄 ${widget.statistics.sentCount}회 / 받음 ${widget.statistics.receivedCount} 회)',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                    children: [
                      const SizedBox(height: 8.0),
                      Text(
                        '${_formatNumber(widget.statistics.totalAmount)}원',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (widget.statistics.sentAmount > 0 ||
                          widget.statistics.receivedAmount > 0)
                        Align(
                          // alignment: Alignment.centerRight, // 우측 정렬
                          child: Text(
                            '(보냄 ${_formatNumber(widget.statistics.sentAmount)}원 / 받음 ${_formatNumber(widget.statistics.receivedAmount)}원)',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      if (widget.statistics.sentAmount == 0 &&
                          widget.statistics.receivedAmount == 0)
                        Text(
                          '보냄 0건 / 받음 0건',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
