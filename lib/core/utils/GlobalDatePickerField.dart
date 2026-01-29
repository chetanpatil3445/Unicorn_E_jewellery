import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/appcolors.dart';

class GlobalDatePickerField extends StatelessWidget {
  final String labelTxt;
  final TextEditingController controller;

  const GlobalDatePickerField({
    super.key,
    required this.labelTxt,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextFormField(
        style: DefaultStyle18Text,
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: labelTxt,
          labelStyle: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 16,
          ),
          isDense: true,
          focusedBorder:   OutlineInputBorder(
            borderRadius: kBorderRadius,
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1,
            ),
          ),
          enabledBorder:   OutlineInputBorder(
            borderRadius: kBorderRadius,
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1,
            ),
          ),
          border:  OutlineInputBorder(
            borderRadius: kBorderRadius,
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1,
            ),
          ),
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('dd MMM yyyy').format(pickedDate);
            controller.text = formattedDate;
          }
        },
      ),
    );
  }
}
const kBorderRadius = BorderRadius.all(Radius.circular(5));
