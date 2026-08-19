import 'package:flutter/material.dart';

class DiscoverPopover extends StatefulWidget {
  final double width;
  final double maxHeight;
  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final Alignment alignment;
  final Widget Function(BuildContext context, bool isOpen, VoidCallback toggle)
  builder;
  final Widget Function(BuildContext context, VoidCallback hide) contentBuilder;
  final VoidCallback? onOpen;

  const DiscoverPopover({
    super.key,
    required this.builder,
    required this.contentBuilder,
    this.width = 160,
    this.maxHeight = 320,
    this.targetAnchor = Alignment.bottomLeft,
    this.followerAnchor = Alignment.topLeft,
    this.alignment = Alignment.topLeft,
    this.onOpen,
  });

  @override
  State<DiscoverPopover> createState() => _DiscoverPopoverState();
}

class _DiscoverPopoverState extends State<DiscoverPopover> {
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _portalController = OverlayPortalController();

  void _toggle() {
    if (_portalController.isShowing) {
      _hide();
    } else {
      _show();
    }
  }

  void _show() {
    widget.onOpen?.call();
    _portalController.show();
    setState(() {});
  }

  void _hide() {
    if (_portalController.isShowing) {
      _portalController.hide();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _portalController,
        overlayChildBuilder: (context) => Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _hide,
              child: const SizedBox.expand(),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: widget.targetAnchor,
              followerAnchor: widget.followerAnchor,
              offset: const Offset(0, 6),
              child: Align(
                alignment: widget.alignment,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: widget.width,
                    constraints: BoxConstraints(
                      maxHeight: widget.maxHeight,
                      maxWidth: MediaQuery.of(context).size.width - 32,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFF3D2DC),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF9E1068,
                          ).withValues(alpha: 0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: widget.contentBuilder(context, _hide),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        child: widget.builder(context, _portalController.isShowing, _toggle),
      ),
    );
  }
}
