import 'package:flutter/material.dart';

class SignupHeader extends StatelessWidget {
  final VoidCallback onBack;

  const SignupHeader({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back,
              size: 28,
            ),
          ),

          const Spacer(),

          const Text(
            'Heartiqo',
            style: TextStyle(
              color: Color(0xFFC00055),
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          const SizedBox(width: 48),
        ],
      );
}