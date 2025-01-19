import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/%08shared/widgets/custom_date_picker.dart';
import 'package:flutter_onjung_v1/data/%08shared/member.dart';
import 'package:flutter_onjung_v1/data/%08shared/unified_transaction.dart';
import 'package:flutter_onjung_v1/features/address_tab/detailed_screens_components/member_history_list_section.dart';
import 'package:flutter_onjung_v1/features/address_tab/providers/address_book_provider.dart';
import 'package:flutter_onjung_v1/features/home_tab/input_screens/amount_input_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// provider 정의 추가
final addressBookProvider =
    ChangeNotifierProvider((ref) => AddressBookProvider());

class MemberHistoryTab extends ConsumerStatefulWidget {
  final String counterpartId;

  const MemberHistoryTab({super.key, required this.counterpartId});

  @override
  ConsumerState<MemberHistoryTab> createState() => _MemberHistoryTabState();
}

class _MemberHistoryTabState extends ConsumerState<MemberHistoryTab> {
  late DateTime startDate; // 시작 날짜
  late DateTime endDate; // 종료 날짜
  List<dynamic> transactions = []; // counterpartId와 관련된 거래 내역
  String nickname = '';
  String counterpart = '';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    startDate = DateTime(now.year - 1, now.month, now.day);
    endDate = now;

    _loadData();

    // counterpartId와 관련된 거래 내역 불러오기
    _loadTransactions();
  }

  void _loadTransactions() {
    // 거래 데이터를 불러오고 counterpartId와 관련된 데이터를 필터링
    // 여기에 데이터 로드 로직 추가
  }

  void _loadData() {
    // AddressBookProvider를 올바르게 읽어옵니다.
    final addressBook = ref.read(addressBookProvider);

    // 내 닉네임을 가져옵니다.
    setState(() {
      nickname = addressBook.nickname;
    });

    // counterpartId에 해당하는 상대방의 닉네임을 가져옵니다.
    final counterpartNickname = addressBook.getNickname(widget.counterpartId);

    // counterpartId에 해당하는 멤버 데이터를 검색합니다.
    final member = addressBook.members.firstWhere(
      (m) => m.id == widget.counterpartId,
      orElse: () => Member(
        // null 대신 기본 Member 객체 반환
        id: widget.counterpartId,
        name: '알 수 없음',
        registeredDate: DateTime.now(),
        relationship: Relationship.other,
        relationDetail: '',
        transactions: [],
      ),
    );

// member는 이제 항상 Member 객체이므로 null 체크가 필요 없음
    setState(() {
      counterpart = counterpartNickname;
      transactions = member.transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 날짜 필터링
    final List<UnifiedTransaction> filteredRecords = transactions
        .where((transaction) {
          return transaction.date
                  .isAfter(startDate.subtract(const Duration(days: 1))) &&
              transaction.date.isBefore(endDate.add(const Duration(days: 1)));
        })
        .cast<UnifiedTransaction>() // 명시적으로 List<UnifiedTransaction>으로 캐스팅
        .toList();

    final int totalSent = filteredRecords
        .where((r) => r.type == 'sent')
        .fold(0, (sum, r) => sum + r.amount);

    final int totalReceived = filteredRecords
        .where((r) => r.type == 'received')
        .fold(0, (sum, r) => sum + r.amount);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$nickname님은 ',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    '$counterpart님과',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  GestureDetector(
                    onTap: _selectStartDate,
                    child: Text(
                      '${startDate.year}년▼${startDate.month}월▼',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const Text('부터', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _selectEndDate,
                    child: Text(
                      '${endDate.year}년▼${endDate.month}월▼',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const Text('까지', style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '이렇게 온정을 나눴어요',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Text(
                '총 거래 내역: ${filteredRecords.length}회 '
                '(보냄 ${_formatAmount(totalSent)}원 / 받음 ${_formatAmount(totalReceived)}원)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '상세내역',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AmountInputScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: MemberHistoryListSection(
            records: filteredRecords,
            startDate: startDate,
            endDate: endDate,
          ),
        ),
      ],
    );
  }

  String _formatAmount(int amount) {
    return NumberFormat('#,###').format(amount);
  }

  Future<void> _selectStartDate() async {
    final initialYear = startDate.year;
    final initialMonth = startDate.month;

    final result = await showYearMonthPicker(
      context,
      initialYear: initialYear,
      initialMonth: initialMonth,
    );

    if (result != null) {
      final (year, month) = result;
      setState(() {
        startDate = DateTime(year, month, 1);
        if (startDate.isAfter(endDate)) {
          endDate = DateTime(year, month, 1).add(const Duration(days: 30));
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final initialYear = endDate.year;
    final initialMonth = endDate.month;

    final result = await showYearMonthPicker(
      context,
      initialYear: initialYear,
      initialMonth: initialMonth,
    );

    if (result != null) {
      final (year, month) = result;
      setState(() {
        endDate = DateTime(year, month + 1, 0);
        if (endDate.isBefore(startDate)) {
          startDate = DateTime(year, month - 1, 1);
        }
      });
    }
  }
}
