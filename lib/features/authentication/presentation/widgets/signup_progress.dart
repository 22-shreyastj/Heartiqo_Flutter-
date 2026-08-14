import 'package:flutter/material.dart';

class SignupProgress extends StatelessWidget {
  final int step;

  const SignupProgress({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          LinearProgressIndicator(
            value: step / 5,
            minHeight: 5,
            backgroundColor:
                const Color(0xFFFFDDE8),
            valueColor:
                const AlwaysStoppedAnimation(
              Color(0xFFC00055),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Step $step of 5',
            style: const TextStyle(
              color: Color(0xFFC00055),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}