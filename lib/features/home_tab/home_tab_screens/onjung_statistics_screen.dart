import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/widgets/statistics_message_helper.dart';

class OnjungStatisticsScreen extends StatefulWidget {
  @override
  _OnjungStatisticsScreenState createState() => _OnjungStatisticsScreenState();
}

class _OnjungStatisticsScreenState extends State<OnjungStatisticsScreen> {
  final StatisticsMessageHelper _messageHelper = StatisticsMessageHelper();
  String? selectedAgeGroup;
  String? selectedRelation;
  String? selectedLabel;
  List<String> messages = [];

  final List<String> ageGroups = ['10대', '20대', '30대', '40대', '50대', '60대 이상'];
  final List<String> relations = ['가족', '친구', '지인', '직장 동료'];
  final List<String> labels = ['결혼식', '생일', '장례식', '환갑', '집들이', '돌잔치'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _messageHelper.loadData(
      userProfileFilePath: 'assets/user_profiles_network.json',
      transactionFilePath: 'assets/dummy_transactions_network.json',
    );

    _filterMessages();
  }

  void _filterMessages() {
    setState(() {
      messages = _messageHelper.generateMessages(
        ageGroup: selectedAgeGroup,
        relation: selectedRelation,
        label: selectedLabel,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                hint: Text('나이대'),
                value: selectedAgeGroup,
                onChanged: (value) {
                  setState(() {
                    selectedAgeGroup = value;
                    _filterMessages();
                  });
                },
                items: ageGroups.map((age) {
                  return DropdownMenuItem(
                    value: age,
                    child: Text(age),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                hint: Text('관계'),
                value: selectedRelation,
                onChanged: (value) {
                  setState(() {
                    selectedRelation = value;
                    _filterMessages();
                  });
                },
                items: relations.map((relation) {
                  return DropdownMenuItem(
                    value: relation,
                    child: Text(relation),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                hint: Text('카테고리'),
                value: selectedLabel,
                onChanged: (value) {
                  setState(() {
                    selectedLabel = value;
                    _filterMessages();
                  });
                },
                items: labels.map((label) {
                  return DropdownMenuItem(
                    value: label,
                    child: Text(label),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: messages.isEmpty
                ? Center(child: Text('조건에 맞는 문구가 없습니다.'))
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
