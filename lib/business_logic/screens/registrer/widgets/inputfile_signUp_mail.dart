import 'package:flutter/material.dart';

import '../../../constants.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final IconData prefixIcon;
  final bool obscureText;

  const CustomInputField({
    required this.label,
    required this.prefixIcon,
    this.obscureText = false,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  var bank = TextEditingController();
  var acctNum = TextEditingController();
  var narration = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(kPaddingM),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
        ),
        hintText: widget.label,
        hintStyle: TextStyle(
          color: kBlack.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          widget.prefixIcon,
          color: kBlack.withOpacity(0.5),
        ),
      ),
      obscureText: widget.obscureText,
    );
  }
}
