// import 'package:flutter/material.dart';
//
// Widget dropdown(String label, String? value, List<dynamic> items, Function(String?) onChanged,
//     {String? displayKey, String? valueKey}) {
//   return DropdownButtonFormField<String>(
//     value: value,
//     decoration: InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(fontSize: 12),
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.shade300)),
//       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 1.8)),
//     ),
//     items: items.map((e) {
//       final d = displayKey != null ? e[displayKey] : e.toString();
//       final v = valueKey != null ? e[valueKey].toString() : e.toString();
//       return DropdownMenuItem(value: v, child: Text(d, style: const TextStyle(fontSize: 13)));
//     }).toList(),
//     onChanged: onChanged,
//     dropdownColor: Colors.white,
//     icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFF0D47A1)),
//   );
// }

import 'package:flutter/material.dart';

Widget dropdown(
    String label,
    String? value,
    List<dynamic> items,
    Function(String?) onChanged, {
      String? displayKey,
      String? valueKey,
      bool readOnly = false, // 👈 added
    }) {
  return DropdownButtonFormField<String>(
    value: value,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 12),
      filled: true,
      fillColor: readOnly ? Colors.grey.shade100 : Colors.white, // optional visual
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 1.8),
      ),
    ),
    items: items.map((e) {
      final d = displayKey != null ? e[displayKey] : e.toString();
      final v = valueKey != null ? e[valueKey].toString() : e.toString();
      return DropdownMenuItem(
        value: v,
        child: Text(d, style: const TextStyle(fontSize: 13)),
      );
    }).toList(),

    // 👇 readOnly true => user change nahi kar payega
    onChanged: readOnly ? null : onChanged,

    dropdownColor: Colors.white,
    icon: const Icon(
      Icons.keyboard_arrow_down_rounded,
      size: 18,
      color: Color(0xFF0D47A1),
    ),
  );
}
