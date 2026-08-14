import 'package:flutter/material.dart';

class SignupPrimaryButton
    extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const SignupPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) =>
      Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE5005A),
              Color(0xFFB420C9),
            ],
          ),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(
                  icon,
                  color: Colors.white,
                ),
              ],
            ],
          ),
        ),
      );
}