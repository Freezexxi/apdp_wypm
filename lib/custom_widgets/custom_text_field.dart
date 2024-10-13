import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final Color borderColor;
  final double borderRadius;
  final Color placeholderColor;
  final Color backgroundColor;
  final bool isFilled;
  final TextStyle textStyle;
  final int? minLines;
  final int? maxLines;
  final FormFieldValidator<String>? validator;
  final Icon? prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.borderColor,
    required this.borderRadius,
    required this.placeholderColor,
    required this.backgroundColor,
    required this.isFilled,
    required this.textStyle,
    this.minLines,
    this.maxLines,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: isFilled,
        fillColor: backgroundColor,
        hintText: placeholder,
        hintStyle: TextStyle(color: placeholderColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        prefixIcon: prefixIcon, // Use prefix icon here
      ),
      style: textStyle,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
    );
  }
}
