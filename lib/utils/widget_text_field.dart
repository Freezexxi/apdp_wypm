import 'package:flutter/material.dart';

class WidgetTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int? minLines;
  final int? maxLines;
  final String? Function(String?)? validator;
  final bool readonly;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color borderColor;
  final double borderRadius;
  final Color hintColor;
  final TextStyle? textStyle;
  final Color fillColor;
  final bool filled;

  const WidgetTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.minLines,
    this.maxLines,
    this.validator,
    this.readonly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.borderColor = Colors.blueGrey,
    this.borderRadius = 8.0,
    this.hintColor = Colors.grey,
    this.textStyle,
    this.fillColor = Colors.white,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readonly,
      controller: controller,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines ?? 1,
      validator: validator,
      obscureText: obscureText,
      style: textStyle,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor),
        fillColor: filled ? fillColor : null,
        filled: filled,
        border: readonly
            ? InputBorder.none
            : OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: borderColor)
            : null,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: borderColor)
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: 2.0),
        ),
      ),
    );
  }
}
