import 'package:flutter/material.dart';

import '../utils/GlobalDatePickerField.dart';
import 'appcolors.dart';

InputDecoration buildDropdownDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(
        color: cyanColor, fontWeight: FontWeight.w600, fontSize: 13),
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: borderColor, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: accentColor, width: 2),
    ),
    contentPadding:
    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
  );
}

BoxDecoration buildTableDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: cyanColor.withOpacity(0.08),
        spreadRadius: 1,
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ],
  );
}


InputDecoration DropdownDecoration(String labelText) {
  return InputDecoration(
    fillColor: Colors.white,
    filled: true,
    labelText: labelText,
    labelStyle: const TextStyle(
      color: Colors.grey,
    ),
    isDense: true,

    contentPadding: EdgeInsets.only(left: 5),

    focusedBorder: OutlineInputBorder(
      borderRadius: kBorderRadius,
      borderSide: BorderSide(
        color: Colors.grey,
        width: 0.3,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: kBorderRadius,
      borderSide: BorderSide(
        color: Colors.grey,
        width: 0.3,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: kBorderRadius,
      borderSide:   BorderSide(
        color: Colors.grey,
        width: 0.3,
      ),
    ),
  );
}
InputDecoration customInputDecoration1(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(
      color: Colors.grey,
    ),
    //isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 8.0), // Adjust horizontal padding
    focusedBorder: OutlineInputBorder(
      borderRadius: kBorderRadius,
      borderSide: BorderSide(
        color: Colors.grey,
        width: 0.3,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: kBorderRadius,
      borderSide: BorderSide(
        color: Colors.grey,
        width: 0.3,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: kBorderRadius,
      borderSide: BorderSide(
        color: Colors.grey,
        width: 0.3,
      ),
    ),
  );
}
