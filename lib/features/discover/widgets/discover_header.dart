import 'package:flutter/material.dart';

class DiscoverHeader extends StatelessWidget {
  final String? avatarUrl;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSearchTap;
  final bool showAvatar;
  final bool showSearchOnLeft;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const DiscoverHeader({
    super.key,
    this.avatarUrl,
    this.onNotificationTap,
    this.onSearchTap,
    this.showAvatar = true,
    this.showSearchOnLeft = false,
    this.showBackButton = false,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget leftWidget;
    if (showBackButton) {
      leftWidget = _HeaderIconButton(
        icon: Icons.arrow_back_rounded,
        onTap: onBackTap ?? () => Navigator.of(context).pop(),
      );
    } else if (showSearchOnLeft) {
      leftWidget = _HeaderIconButton(
        icon: Icons.search_rounded,
        onTap: onSearchTap,
      );
    } else if (showAvatar) {
      leftWidget = Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFF3DDE4), width: 1.5),
        ),
        child: ClipOval(
          child: avatarUrl != null && avatarUrl!.isNotEmpty
              ? Image.network(
                  avatarUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const _AvatarFallback(),
                )
              : const _AvatarFallback(),
        ),
      );
    } else {
      leftWidget = const SizedBox(width: 42);
    }

    final rightWidgets = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!showSearchOnLeft && !showBackButton && onSearchTap != null) ...[
          _HeaderIconButton(icon: Icons.search_rounded, onTap: onSearchTap),
          const SizedBox(width: 8),
        ],
        _HeaderIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: onNotificationTap,
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 42,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Left Action
            Align(alignment: Alignment.centerLeft, child: leftWidget),

            // Visually Centered Title
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 96),
                child: const Text(
                  'Heartiqo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8A0B3B),
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Right Actions
            Align(alignment: Alignment.centerRight, child: rightWidgets),
          ],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _HeaderIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFFFDF0F3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF5A2A3A), size: 22),
        ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFDEEF2),
      child: const Icon(
        Icons.person_rounded,
        color: Color(0xFF8A0B3B),
        size: 24,
      ),
    );
  }
}
