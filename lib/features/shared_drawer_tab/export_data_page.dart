// export_data_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExportDataPage extends StatefulWidget {
  const ExportDataPage({super.key});

  @override
  State<ExportDataPage> createState() => _ExportDataPageState();
}

class _ExportDataPageState extends State<ExportDataPage> {
  final Set<String> _selectedData = {'profile', 'posts', 'comments'};
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String _exportFormat = 'CSV';

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('데이터 내보내기'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '내보낼 데이터 선택',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: const Text('프로필 정보'),
                      subtitle: const Text('기본 정보, 설정 등'),
                      value: _selectedData.contains('profile'),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value ?? false) {
                            _selectedData.add('profile');
                          } else {
                            _selectedData.remove('profile');
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('게시물'),
                      subtitle: const Text('작성한 게시물, 이미지 등'),
                      value: _selectedData.contains('posts'),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value ?? false) {
                            _selectedData.add('posts');
                          } else {
                            _selectedData.remove('posts');
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('댓글'),
                      subtitle: const Text('작성한 댓글, 리액션 등'),
                      value: _selectedData.contains('comments'),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value ?? false) {
                            _selectedData.add('comments');
                          } else {
                            _selectedData.remove('comments');
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '기간 설정',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('시작일'),
                      subtitle: Text(
                        DateFormat('yyyy년 MM월 dd일').format(_startDate),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context, true),
                    ),
                    ListTile(
                      title: const Text('종료일'),
                      subtitle: Text(
                        DateFormat('yyyy년 MM월 dd일').format(_endDate),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context, false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '파일 형식',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RadioListTile(
                      title: const Text('CSV'),
                      value: 'CSV',
                      groupValue: _exportFormat,
                      onChanged: (String? value) {
                        setState(() {
                          _exportFormat = value ?? 'CSV';
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('JSON'),
                      value: 'JSON',
                      groupValue: _exportFormat,
                      onChanged: (String? value) {
                        setState(() {
                          _exportFormat = value ?? 'JSON';
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('Excel'),
                      value: 'Excel',
                      groupValue: _exportFormat,
                      onChanged: (String? value) {
                        setState(() {
                          _exportFormat = value ?? 'Excel';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: 실제 데이터 내보내기 로직 구현
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('데이터 내보내기'),
                      content: const Text('선택한 데이터를 내보내시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('취소'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // 데이터 내보내기 작업 시작
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('데이터 내보내기가 시작되었습니다.'),
                              ),
                            );
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('내보내기'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
