import 'package:flutter/material.dart';

class CustomRadioGroup<T> extends StatelessWidget {
  final T selectedValue;
  final List<T> values;
  final List<String> labels;
  final ValueChanged<T?> onChanged;

  const CustomRadioGroup({
    Key? key,
    required this.selectedValue,
    required this.values,
    required this.labels,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(values.length, (index) {
        return GestureDetector(
          onTap: () => onChanged(values[index]),
          child: Row(
            children: [
              Radio<T>(
                value: values[index],
                groupValue: selectedValue,
                onChanged: onChanged,
              ),
              Text(labels[index], style: const TextStyle(fontSize: 16)),
            ],
          ),
        );
      }),
    );
  }
}
