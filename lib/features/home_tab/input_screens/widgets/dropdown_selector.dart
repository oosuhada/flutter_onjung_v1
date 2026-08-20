import 'package:flutter/material.dart';

class DropdownSelector extends StatelessWidget {
  final String label;
  final List<String> options;

  const DropdownSelector({
    Key? key,
    required this.label,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          items: options
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: (value) {
            // 로직 추가 가능
          },
        ),
      ],
    );
  }
}
