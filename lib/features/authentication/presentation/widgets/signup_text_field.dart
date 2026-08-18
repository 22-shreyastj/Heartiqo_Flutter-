import 'package:flutter/material.dart';

class SignupTextField extends StatelessWidget {
  final String hint;
  final String? helperText;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const SignupTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.helperText,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,

          helperText: helperText,

          helperStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),

          helperMaxLines: 2,

          suffixIcon: suffixIcon,

          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),

          border: const OutlineInputBorder(),

          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFC00055),
              width: 1.5,
            ),
          ),
        ),
      );
}