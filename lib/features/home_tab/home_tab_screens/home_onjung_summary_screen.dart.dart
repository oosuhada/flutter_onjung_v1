import 'package:flutter/material.dart';

class HomeOnjungSummaryScreen extends StatelessWidget {
  const HomeOnjungSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '최근 6개월간 쓴 금액',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          // 그래프 추가
          Container(
            height: 200,
            color: Colors.orange[100], // 임시 그래프 영역
            child: const Center(child: Text('그래프 영역')),
          ),
          const SizedBox(height: 16.0),
          const Text(
            '최다 온정 관계: 친구 (2번)',
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          const Text(
            '최다 온정 경조사: 생일 기념일 (2번)',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
