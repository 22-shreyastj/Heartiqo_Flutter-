import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';

class OtpCodeInput extends StatelessWidget {
  final List<String> digits;
  final int length;

  const OtpCodeInput({
    super.key,
    required this.digits,
    this.length = 4,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;

        final availableWidth =
            constraints.maxWidth - (spacing * (length - 1));

        final boxWidth = (availableWidth / length).clamp(
          48.0,
          64.0,
        );

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(length, (index) {
            final value = index < digits.length ? digits[index] : '';

            final isFilled = value.isNotEmpty;

            final isActive = digits.length == index;

            return Padding(
              padding: EdgeInsets.only(
                right: index == length - 1 ? 0 : spacing,
              ),
              child: OtpDigitBox(
                value: value,
                isFilled: isFilled,
                isActive: isActive,
                width: boxWidth,
              ),
            );
          }),
        );
      },
    );
  }
}

class OtpDigitBox extends StatelessWidget {
  final String value;
  final bool isFilled;
  final bool isActive;
  final double width;

  const OtpDigitBox({
    super.key,
    required this.value,
    required this.isFilled,
    required this.isActive,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: width,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isFilled
            ? AppColors.darkPurple
            : Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: isFilled
              ? AppColors.darkPurple
              : isActive
                  ? AppColors.darkPurple
                  : AppColors.darkPurple.withValues(alpha: 0.18),
          width: isActive || isFilled ? 2 : 1.2,
        ),

        boxShadow: [
          if (isFilled)
            BoxShadow(
              color: AppColors.darkPurple.withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),

      child: Text(
        value,
        style: TextStyle(
          color: isFilled
              ? Colors.white
              : AppColors.darkPurple,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}