import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';

class GoogleLoginButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const GoogleLoginButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  State<GoogleLoginButton> createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<GoogleLoginButton>
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

    _iconSlide = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _buttonScale = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.75,
          curve: Curves.easeOut,
        ),
      ),
    );

    _buttonOpacity = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.65,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    await _controller.forward();

    if (!mounted) return;

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final maxSlide =
                        constraints.maxWidth - 52;

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // ----------------------------------------
                        // TEXT
                        // ----------------------------------------

                        Text(
                          widget.label,
                          style: TextStyle(
                            color: AppColors.darkPurple,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // ----------------------------------------
                        // GOOGLE ICON
                        // ----------------------------------------

                        Positioned(
                          left: 6 + (_iconSlide.value * maxSlide),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black12,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'G',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkPurple,
                                ),
                              ),
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
}