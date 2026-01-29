import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../constants/appcolors.dart';

class CustomDropdownButtonFormField extends StatelessWidget {
  final String labelText;
  final List<Map<String, dynamic>> items;
  final String? value;
  final Function(dynamic)? onChanged;
  final Color? dropdownColor;
  final Color? menuItemTextColor;
  final Color? menuItemActiveColor;

  const CustomDropdownButtonFormField({
    super.key,
    required this.labelText,
    required this.items,
    this.value,
    this.onChanged,
    this.dropdownColor,
    this.menuItemTextColor,
    this.menuItemActiveColor,
  });

  static const kBorderRadius = BorderRadius.all(Radius.circular(5));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: DropdownButtonFormField2(
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 16,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.only(left: 5),
          focusedBorder: OutlineInputBorder(
            borderRadius: kBorderRadius,
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: kBorderRadius,
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: kBorderRadius,
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1,
            ),
          ),
        ),
        isExpanded: true,
        isDense: true,
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: AllTextColor,
            size: 30,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: dropdownColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          selectedMenuItemBuilder: (context, child) {
            return Container(
              color: menuItemActiveColor,
              child: child,
            );
          },
        ),
        buttonStyleData: const ButtonStyleData(height: 49),
        hint: AutoSizeText(
          overflow: TextOverflow.ellipsis,
          labelText,
          maxLines: 1,
          minFontSize: 9,
          maxFontSize: 16,
        ),
        value: value,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((item) {
          return DropdownMenuItem<String>(
            value: item['value'].toString(),
            child: AutoSizeText(
              "${item['display']} ${item['suffix']}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              minFontSize: 9,
              maxFontSize: 16,
              style: DefaultStyle18Text.copyWith(color: menuItemTextColor),
            ),
          );
        }).toList(),
      ),
    );
  }
}


class CustomDropdownButtonFormField2<T> extends StatelessWidget {
  final String labelText;
  final List<T> items;
  final T? value;
  final String Function(T) displayStringFor;
  final void Function(T?)? onChanged;

  const CustomDropdownButtonFormField2({
    Key? key,
    required this.labelText,
    required this.items,
    this.value,
    required this.displayStringFor,
    this.onChanged,
  }) : super(key: key);

  static const kBorderRadius = BorderRadius.all(Radius.circular(5));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: DropdownButtonFormField2<T>(
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.only(left: 5),
          focusedBorder: OutlineInputBorder(
            borderRadius: kBorderRadius,
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: kBorderRadius,
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: kBorderRadius,
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        isExpanded: true,
        isDense: true,
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Color(0xFF555555),
            size: 25,
          ),
        ),
        buttonStyleData: const ButtonStyleData(height: 49),
        hint: Text(
          labelText,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontSize: 16),
        ),
        value: value,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<T>>((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              displayStringFor(item),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          );
        }).toList(),
      ),
    );
  }
}