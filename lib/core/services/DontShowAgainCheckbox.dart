import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/appcolors.dart';
import 'TooltipStorage.dart';

class DontShowAgainCheckbox extends StatefulWidget {
  const DontShowAgainCheckbox({super.key});

  @override
  State<DontShowAgainCheckbox> createState() => _DontShowAgainCheckboxState();
}

class _DontShowAgainCheckboxState extends State<DontShowAgainCheckbox> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: checked,
          activeColor: Colors.white,
          checkColor: primaryPurple,
          onChanged: (val) {
            setState(() => checked = val!);
            if (checked) {
              TooltipStorage.hideForever();
            }
          },
        ),
        Expanded(
          child: Text(
            "Don’t show tips again",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}
