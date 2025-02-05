// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter_onjung_v1/data/statistics_models.dart';

// // 거래 데이터 로드 함수
// Future<List<Map<String, dynamic>>> loadTransactionsFromFile(
//     String filePath) async {
//   final file = File(filePath);
//   final content = await file.readAsString();
//   final data = json.decode(content);
//   return List<Map<String, dynamic>>.from(data['transactions']);
// }

// // 월별 통계 계산
// Map<String, int> calculateMonthlyAmounts(
//     List<Map<String, dynamic>> transactions) {
//   Map<String, int> monthlyAmounts = {};
//   for (var transaction in transactions) {
//     final dateParts = transaction["date"].split('-');
//     final key = "${dateParts[0]}-${dateParts[1]}";
//     monthlyAmounts[key] =
//         (monthlyAmounts[key] ?? 0) + transaction["amount"] as int;
//   }
//   return monthlyAmounts;
// }

// // StatisticsSummary 생성 함수
// Future<StatisticsSummary> generateStatisticsSummary({
//   required PeriodRange period,
// }) async {
//   // 거래 데이터 로드
//   const filePath = 'assets/dummy_transactions.json';
//   final transactions = await loadTransactionsFromFile(filePath);

//   // 선택된 기간에 해당하는 데이터 필터링
//   final filteredTransactions = transactions.where((t) {
//     final dateParts = t["date"].split('-').map(int.parse).toList();
//     final transactionDate = DateTime(dateParts[0], dateParts[1]);

//     return !transactionDate
//             .isBefore(DateTime(period.startYear, period.startMonth)) &&
//         !transactionDate.isAfter(DateTime(period.endYear, period.endMonth));
//   }).toList();

//   // 월별 통계 계산
//   final monthlyAmounts = calculateMonthlyAmounts(filteredTransactions);

//   // StatisticsSummary 객체 생성 및 반환
//   return StatisticsSummary(
//     nickname: '르탄이',
//     period: period,
//     totalCount: filteredTransactions.length,
//     sentCount: filteredTransactions.where((t) => t["type"] == "sent").length,
//     receivedCount:
//         filteredTransactions.where((t) => t["type"] == "received").length,
//     totalAmount: filteredTransactions.fold(
//       0,
//       (sum, t) => sum + t["amount"] as int,
//     ),
//     sentAmount: filteredTransactions
//         .where((t) => t["type"] == "sent")
//         .fold(0, (sum, t) => sum + t["amount"] as int),
//     receivedAmount: filteredTransactions
//         .where((t) => t["type"] == "received")
//         .fold(0, (sum, t) => sum + t["amount"] as int),
//     monthlyAmounts: monthlyAmounts,
//   );
// }

// // // 테스트용 main 함수 (선택적으로 제거 가능)
// // void main() async {
// //   final period = PeriodRange(
// //     startYear: 2024,
// //     startMonth: 1,
// //     endYear: 2024,
// //     endMonth: 12,
// //   );

// //   // StatisticsSummary 생성
// //   final statistics = await generateStatisticsSummary(period: period);

// //   // 결과 출력
// //   print('Statistics for Period: ${statistics.period.startYear}/${statistics.period.startMonth} ~ ${statistics.period.endYear}/${statistics.period.endMonth}');
// //   print('Total Transactions: ${statistics.totalCount}');
// //   print('Monthly Amounts: ${statistics.monthlyAmounts}');
// // }
