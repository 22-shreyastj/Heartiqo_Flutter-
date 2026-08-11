import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';

class AuthPrimaryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  final bool animateIcon;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.animateIcon = true,
  });

  @override
  State<AuthPrimaryButton> createState() => _AuthPrimaryButtonState();
}

class _AuthPrimaryButtonState extends State<AuthPrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _iconSlide;
  late final Animation<double> _buttonScale;
  late final Animation<double> _buttonOpacity;

  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _iconSlide = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _buttonScale = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
      ),
    );

    _buttonOpacity = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ============================================================
  // TAP
  // ============================================================

  Future<void> _handleTap() async {
    // NORMAL BUTTON
    if (!widget.animateIcon) {
      widget.onTap();
      return;
    }

    // ANIMATED BUTTON
    if (_isAnimating) {
      return;
    }

    setState(() {
      _isAnimating = true;
    });

    await _controller.forward();

    if (!mounted) {
      return;
    }

    widget.onTap();
  }

  // ============================================================
  // NORMAL BUTTON
  // ============================================================

  Widget _buildNormalButton() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 58,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.darkPurple,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ANIMATED BUTTON
  // ============================================================

  Widget _buildAnimatedButton() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScale.value,
          child: Opacity(
            opacity: _buttonOpacity.value,
            child: GestureDetector(
              onTap: _handleTap,
              child: Container(
                height: 58,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.darkPurple,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final maxSlide = constraints.maxWidth - 52;

                    final iconLeft = 6 + (_iconSlide.value * maxSlide);

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          widget.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Positioned(
                          left: iconLeft,
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              widget.icon,
                              color: AppColors.darkPurple,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (!widget.animateIcon) {
      return _buildNormalButton();
    }

    return _buildAnimatedButton();
  }
}
