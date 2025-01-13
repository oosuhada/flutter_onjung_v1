// personal_header_section.dart
import 'package:flutter/material.dart';

class PersonalHeaderSection extends StatelessWidget {
  final String nickname;
  final int totalContacts;
  final String sortOption;
  final ValueChanged<String> onSortChanged; // 정렬 옵션 변경 콜백

  const PersonalHeaderSection({
    Key? key,
    required this.nickname,
    required this.totalContacts,
    required this.sortOption,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$nickname님의 온정인',
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
                '총 $totalContacts명',
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
              Text('전체 ($totalContacts)'),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => onSortChanged('name'),
                    icon: const Icon(Icons.sort_by_alpha, size: 20),
                    label: Text(
                      '이름순',
                      style: TextStyle(
                        fontWeight: sortOption == 'name'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => onSortChanged('date'),
                    icon: const Icon(Icons.date_range, size: 20),
                    label: Text(
                      '최신순',
                      style: TextStyle(
                        fontWeight: sortOption == 'date'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
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
