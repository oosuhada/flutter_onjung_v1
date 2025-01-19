// group_header_section.dart
import 'package:flutter/material.dart';

class GroupHeaderSection extends StatelessWidget {
  final String nickname;
  final int totalGroups;

  const GroupHeaderSection({
    Key? key,
    required this.nickname,
    required this.totalGroups,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$nickname님의 그룹',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '총 $totalGroups개',
                style: const TextStyle(fontSize: 21),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  textStyle: const TextStyle(fontSize: 10),
                  fixedSize: const Size(20, 20),
                ),
                child: const Text('분석'),
              ),
            ],
          ),
          const Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('전체 ($totalGroups)'),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.sort, size: 20),
                    label: const Text('이름순'),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 20),
                    label: const Text('편집'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
