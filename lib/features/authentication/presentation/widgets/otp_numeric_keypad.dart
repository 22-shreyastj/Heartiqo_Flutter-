import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';

class OtpNumericKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyTap;
  final VoidCallback onDelete;
  final bool disabled;

  const OtpNumericKeypad({
    super.key,
    required this.onKeyTap,
    required this.onDelete,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    const numbers = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '',
      '0',
      'back',
    ];

    return Column(
      children: [
        for (var row = 0; row < 4; row++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: List.generate(3, (col) {
                final index = row * 3 + col;
                final value = numbers[index];

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: value.isEmpty
                        ? const SizedBox(
                            height: 68,
                          )
                        : _OtpKeyButton(
                            label: value == 'back' ? null : value,
                            icon: value == 'back'
                                ? Icons.backspace_outlined
                                : null,
                            onTap: disabled
                                ? null
                                : () {
                                    if (value == 'back') {
                                      onDelete();
                                    } else {
                                      onKeyTap(value);
                                    }
                                  },
                          ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _OtpKeyButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback? onTap;

  const _OtpKeyButton({
    this.label,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.15,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.darkPurple.withValues(alpha: 0.12),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: icon != null
                  ? Icon(
                      icon,
                      color: AppColors.darkPurple,
                      size: 23,
                    )
                  : Text(
                      label ?? '',
                      style: const TextStyle(
                        color: AppColors.darkPurple,
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}