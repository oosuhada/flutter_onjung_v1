import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/my_onjung_tab/screens/create_event_contacts_screen.dart';
import 'package:go_router/go_router.dart';

class CreateEventDetailsScreen extends StatefulWidget {
  final String eventType;

  const CreateEventDetailsScreen({
    Key? key,
    required this.eventType,
  }) : super(key: key);

  @override
  State<CreateEventDetailsScreen> createState() =>
      _CreateEventDetailsScreenState();
}

class _CreateEventDetailsScreenState extends State<CreateEventDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TextEditingController eventNameController = TextEditingController();

  @override
  void dispose() {
    eventNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('경조사 추가'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '경조사의 제목과 진행 날짜를 알려주세요',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: eventNameController,
                decoration: const InputDecoration(
                  labelText: '경조사 이름',
                  border: OutlineInputBorder(),
                  hintText: '민수 & 예은',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '경조사 이름을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                '진행 날짜',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildDatePicker(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateEventContactsScreen(
                          eventDetails: {
                            'eventType': widget.eventType,
                            'eventName': eventNameController.text,
                            'eventDate': selectedDate,
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('다음'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Row(
      children: [
        Expanded(
          child: _buildDropdownField(
            value: selectedDate.year.toString(),
            items: List.generate(10, (index) => (2024 + index).toString()),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedDate = DateTime(
                    int.parse(value),
                    selectedDate.month,
                    selectedDate.day,
                  );
                });
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDropdownField(
            value: selectedDate.month.toString(),
            items: List.generate(12, (index) => (index + 1).toString()),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedDate = DateTime(
                    selectedDate.year,
                    int.parse(value),
                    selectedDate.day,
                  );
                });
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDropdownField(
            value: selectedDate.day.toString(),
            items: List.generate(31, (index) => (index + 1).toString()),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedDate = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    int.parse(value),
                  );
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        isExpanded: true,
        underline: Container(),
      ),
    );
  }
}
