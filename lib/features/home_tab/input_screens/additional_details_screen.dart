import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/home_tab/input_screens/widgets/custom_text_field.dart';
import 'package:flutter_onjung_v1/features/home_tab/input_screens/widgets/dropdown_selector.dart';

class AdditionalDetailsScreen extends StatelessWidget {
  const AdditionalDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('더 기록할 내용이 있나요?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DropdownSelector(
              label: '방문 여부',
              options: ['방문 안함', '방문함'],
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: '선물',
              hint: '선물을 입력하세요',
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: '메모',
              hint: '메모를 입력하세요',
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: '받은 이유 연락처',
              hint: '연락처를 입력하세요',
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}
