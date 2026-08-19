import 'package:flutter/material.dart';

class DiscoverSearchInput extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final String hintText;

  const DiscoverSearchInput({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.hintText = 'Search interests or names',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2C4CE), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9E1068).withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF2E0F1A),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8D737D),
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 14, right: 10),
              child: Icon(
                Icons.search_rounded,
                color: Color(0xFF7A5A66),
                size: 22,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 46,
              minHeight: 22,
            ),
            suffixIcon: controller != null && controller!.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF8D737D),
                      size: 20,
                    ),
                    onPressed: () {
                      controller?.clear();
                      onClear?.call();
                      onChanged?.call('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 14,
            ),
          ),
        ),
      ),
    );
  }
}
