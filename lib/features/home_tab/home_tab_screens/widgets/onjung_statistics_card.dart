import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/widgets/statistics_message_helper.dart';

class RandomOnjungStatisticsCard extends StatefulWidget {
  const RandomOnjungStatisticsCard({super.key});

  @override
  State<RandomOnjungStatisticsCard> createState() =>
      _RandomOnjungStatisticsCardState();
}

class _RandomOnjungStatisticsCardState
    extends State<RandomOnjungStatisticsCard> {
  String _randomMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAndSetRandomMessage();
  }

  Future<void> _loadAndSetRandomMessage() async {
    final helper = StatisticsMessageHelper();

    // 데이터 로드 (경로는 적절히 수정)
    await helper.loadData(
      userProfileFilePath: 'assets/user_profiles_network.json',
      transactionFilePath: 'assets/dummy_transactions_network.json',
    );

    // 메시지 생성 및 필터링
    final messages = helper.filterMessages();
    debugPrint('Generated Messages: $messages');

    // 무작위 메시지 출력
    final randomMessage = helper.getRandomMessage();
    debugPrint('Random Message: $randomMessage');

    setState(() {
      _randomMessage = randomMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '평균 온정지수 보기',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _randomMessage.isEmpty ? '데이터를 불러오는 중...' : _randomMessage,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
