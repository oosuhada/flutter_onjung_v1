import 'package:flutter/material.dart';

class AmountButtons extends StatelessWidget {
  const AmountButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amounts = [10000, 30000, 50000, 100000, 500000];
    return Wrap(
      spacing: 8.0,
      children: amounts.map((amount) {
        return ElevatedButton(
          onPressed: () {
            // 로직 추가 가능
          },
          child: Text('${amount.toString()}원'),
        );
      }).toList(),
    );
  }
}
