import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  final String name;

  const TypingIndicator({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 18,
        bottom: 8,
      ),
      child: Text(
        '$name is typing...',
        style: const TextStyle(
          color: Color(0xFFD41470),
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}