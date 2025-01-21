import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:go_router/go_router.dart';

class TermsAndConditionsDialog extends StatefulWidget {
  const TermsAndConditionsDialog({super.key});

  @override
  State<TermsAndConditionsDialog> createState() =>
      _TermsAndConditionsDialogState();
}

class _TermsAndConditionsDialogState extends State<TermsAndConditionsDialog> {
  bool allChecked = false;
  List<bool> individualChecked = [false, false, false, false, false];

  void toggleAllCheckboxes(bool? value) {
    setState(() {
      allChecked = value ?? false;
      individualChecked = List.filled(individualChecked.length, allChecked);
    });
  }

  void toggleIndividualCheckbox(int index, bool? value) {
    setState(() {
      individualChecked[index] = value ?? false;
      allChecked = individualChecked.every((checked) => checked);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        checkboxTheme: CheckboxThemeData(
          side: const BorderSide(color: Colors.grey), // 비활성화 상태 테두리 색상 설정
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    "약관 동의",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: allChecked,
                  onChanged: toggleAllCheckboxes,
                  title: const Text(
                    "모두 동의합니다",
                    style: TextStyle(fontSize: 16), // 텍스트 크기 설정
                  ),
                  activeColor: Colors.orange, // 활성화 상태 색상 설정
                ),
                const Divider(),
                _buildCheckableListTile(
                  index: 0,
                  title: "(필수) 만 14세 이상입니다",
                ),
                _buildCheckableListTile(
                  index: 1,
                  title: "(필수) 서비스 이용약관",
                ),
                _buildCheckableListTile(
                  index: 2,
                  title: "(필수) 개인정보 수집 및 이용에 대한 안내",
                ),
                _buildCheckableListTile(
                  index: 3,
                  title: "(선택) 개인정보 수집 및 이용에 대한 안내",
                ),
                _buildCheckableListTile(
                  index: 4,
                  title: "(선택) 이벤트 등 멤버십 정보 수신",
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: individualChecked[0] &&
                          individualChecked[1] &&
                          individualChecked[2]
                      ? () {
                          context.push(AppRoute.authSignup
                              .path); // context.go 대신 context.push 사용
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text("다음"),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckableListTile({
    required int index,
    required String title,
  }) {
    return CheckboxListTile(
      value: individualChecked[index],
      onChanged: (value) => toggleIndividualCheckbox(index, value),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14), // 텍스트 크기 설정
      ),
      activeColor: Colors.orange, // 활성화 상태 색상 설정
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
