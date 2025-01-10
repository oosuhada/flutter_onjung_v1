// voting_page.dart
import 'package:flutter/material.dart';

class VotingPage extends StatelessWidget {
  const VotingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('투표하기'),
      ),
      body: ListView.builder(
        itemCount: 5, // 예시 투표 개수
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '투표 제목 ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('투표 설명이 들어갈 자리입니다.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: 투표 참여 로직 구현
                    },
                    child: const Text('투표 참여하기'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
