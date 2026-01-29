import 'package:flutter/material.dart';
import '../constants/appcolors.dart';
import 'Palette.dart';

class CustomFormField extends StatelessWidget {
  final String? label;
  final String? labelTxt;
  final String? hint;
  final String? initValue;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final bool readOnly;
  final bool obscure;
  final bool mandatory;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Color? fillColor;
  final Color? labelColor;
  final Color? titleColor;
  final EdgeInsetsGeometry? labelPadding;
  final FocusNode? focusNode;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? counter;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final TextInputType? keyboardType; // इसे वैकल्पिक बनाएँ

  const CustomFormField({
    Key? key,
    this.label,
    this.labelTxt,
    this.hint,
    this.initValue,
    this.labelStyle,
    this.hintStyle,
    this.textStyle,
    this.readOnly = false,
    this.obscure = false,
    this.mandatory = false,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.fillColor,
    this.labelColor,
    this.titleColor,
    this.labelPadding,
    this.focusNode,
    this.prefix,
    this.suffix,
    this.counter,
    this.controller,
    this.inputType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.sentences,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.border,
    this.enabledBorder,
    this.keyboardType, // वैकल्पिक पैरामीटर
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.grey.shade400),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: labelPadding ?? const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  label!,
                  style: labelStyle ??
                      const TextStyle(
                        fontSize: 14,
                        color: AllTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (mandatory)
                  const Text(
                    ' *',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
              ],
            ),
          ),
        SizedBox(
          height: 45,
          child: TextFormField(
            readOnly: readOnly,
            obscureText: obscure,
            controller: controller,
            initialValue: controller == null ? initValue : null,
            focusNode: focusNode,
            maxLines: maxLines ?? 1,
            minLines: minLines ?? 1,
            maxLength: maxLength,
            keyboardType: keyboardType ?? inputType, // keyboardType का उपयोग करें, यदि यह null है तो inputType पर वापस जाएँ
            textCapitalization: textCapitalization,
            textInputAction: textInputAction ?? TextInputAction.next,
            textAlignVertical: TextAlignVertical.center,
            style: textStyle ??
                const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AllTextColor,
                ),
            decoration: InputDecoration(
              errorStyle: const TextStyle(height: 0.01),
              filled: true,
              fillColor: fillColor ?? Colors.white,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: border ?? defaultBorder,
              enabledBorder: enabledBorder ?? defaultBorder,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: readOnly ? Colors.grey.shade400 : Palette.kToDark,
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
              prefixIcon: prefix,
              suffixIcon: suffix,
              counter: counter,
              hintText: hint,
              labelText: mandatory ? '$labelTxt *' : labelTxt,
              labelStyle: hintStyle ?? TextStyle(
                color: Colors.grey.shade800,
                fontSize: 16,
              ),
              hintStyle: hintStyle ?? const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              isDense: true,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            onChanged: onChanged,
            onTap: onTap,
            onFieldSubmitted: onFieldSubmitted,
            onEditingComplete: onEditingComplete,
          ),
        ),
      ],
    );
  }
}
