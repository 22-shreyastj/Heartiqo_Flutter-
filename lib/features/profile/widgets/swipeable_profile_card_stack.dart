import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../model/profile_model.dart';
import '../service/liked_profiles_service.dart';
import 'profile_card.dart';

class SwipeableProfileCardStack extends StatefulWidget {
  final List<ProfileModel> profiles;
  final int currentIndex;
  final ValueChanged<int> onProfileChanged;
  final VoidCallback onTapCard;
  final VoidCallback onLike;

  const SwipeableProfileCardStack({
    super.key,
    required this.profiles,
    required this.currentIndex,
    required this.onProfileChanged,
    required this.onTapCard,
    required this.onLike,
  });

  @override
  State<SwipeableProfileCardStack> createState() =>
      SwipeableProfileCardStackState();
}

class SwipeableProfileCardStackState extends State<SwipeableProfileCardStack>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<Offset> _dragNotifier =
      ValueNotifier<Offset>(Offset.zero);
  late AnimationController _animController;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..addListener(() {
        if (_slideAnimation != null) {
          _dragNotifier.value = _slideAnimation!.value;
        }
      });
  }

  @override
  void dispose() {
    _animController.dispose();
    _dragNotifier.dispose();
    super.dispose();
  }

  ProfileModel get _currentProfile =>
      widget.profiles[widget.currentIndex % widget.profiles.length];
  ProfileModel get _nextProfile => widget
      .profiles[(widget.currentIndex + 1) % widget.profiles.length];

  void _onPanUpdate(DragUpdateDetails details) {
    if (_animController.isAnimating) return;
    _dragNotifier.value += details.delta;
  }

  void _onPanEnd(DragEndDetails details) {
    if (_animController.isAnimating) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final velocity = details.velocity.pixelsPerSecond.dx;
    final currentDx = _dragNotifier.value.dx;

    if (currentDx > 100 || velocity > 500) {
      LikedProfilesService.instance.addLikedProfile(_currentProfile);
      _animateCardOut(targetDx: screenWidth * 1.5, isLike: true);
    } else if (currentDx < -100 || velocity < -500) {
      _animateCardOut(targetDx: -screenWidth * 1.5, isLike: false);
    } else {
      _resetCardPosition();
    }
  }

  void _resetCardPosition() {
    _slideAnimation = Tween<Offset>(
      begin: _dragNotifier.value,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));

    _animController.forward(from: 0.0).then((_) {
      _dragNotifier.value = Offset.zero;
    });
  }

  void _animateCardOut({required double targetDx, required bool isLike}) {
    final startOffset = _dragNotifier.value;
    final endOffset = Offset(targetDx, startOffset.dy);

    _slideAnimation = Tween<Offset>(
      begin: startOffset,
      end: endOffset,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));

    _animController.forward(from: 0.0).then((_) {
      _onSwipeCompleted(isLike: isLike);
    });
  }

  void swipeLeft() {
    if (_animController.isAnimating) return;
    final screenWidth = MediaQuery.of(context).size.width;
    _animateCardOut(targetDx: -screenWidth * 1.5, isLike: false);
  }

  void swipeRight() {
    if (_animController.isAnimating) return;
    LikedProfilesService.instance.addLikedProfile(_currentProfile);
    final screenWidth = MediaQuery.of(context).size.width;
    _animateCardOut(targetDx: screenWidth * 1.5, isLike: true);
  }

  void _onSwipeCompleted({required bool isLike}) {
    _dragNotifier.value = Offset.zero;
    final nextIndex = (widget.currentIndex + 1) % widget.profiles.length;
    widget.onProfileChanged(nextIndex);

    if (isLike) {
      widget.onLike();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: const {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
        },
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Underneath Preview Card (Next Profile)
          ValueListenableBuilder<Offset>(
            valueListenable: _dragNotifier,
            child: RepaintBoundary(
              child: ProfileCard(
                key: ValueKey<int>(
                    (widget.currentIndex + 1) % widget.profiles.length),
                profile: _nextProfile,
              ),
            ),
            builder: (context, dragOffset, child) {
              final dragFraction =
                  (dragOffset.dx / screenWidth).clamp(-1.0, 1.0).abs();
              final scale = 0.94 + (dragFraction * 0.06);
              final opacity = 0.7 + (dragFraction * 0.3);

              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: child,
                ),
              );
            },
          ),

          // Active Top Card with Swipe Gestures
          GestureDetector(
            onTap: widget.onTapCard,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            behavior: HitTestBehavior.translucent,
            child: ValueListenableBuilder<Offset>(
              valueListenable: _dragNotifier,
              child: RepaintBoundary(
                child: ProfileCard(
                  key: ValueKey<int>(widget.currentIndex),
                  profile: _currentProfile,
                ),
              ),
              builder: (context, dragOffset, child) {
                final dragFraction =
                    (dragOffset.dx / screenWidth).clamp(-1.0, 1.0);
                final rotationAngle = dragFraction * 0.25;

                return Transform.translate(
                  offset: dragOffset,
                  child: Transform.rotate(
                    angle: rotationAngle,
                    alignment: Alignment.bottomCenter,
                    child: child,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
