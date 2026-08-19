import 'package:flutter/material.dart';

class DiscoverDistanceDropdown extends StatefulWidget {
  final String selectedDistance;
  final List<String> options;
  final ValueChanged<String> onSelected;
  final Widget Function(BuildContext context, bool isOpen, VoidCallback toggle)
  builder;

  const DiscoverDistanceDropdown({
    super.key,
    required this.selectedDistance,
    required this.options,
    required this.onSelected,
    required this.builder,
  });

  @override
  State<DiscoverDistanceDropdown> createState() =>
      _DiscoverDistanceDropdownState();
}

class _DiscoverDistanceDropdownState extends State<DiscoverDistanceDropdown> {
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _portalController = OverlayPortalController();

  void _toggle() {
    _portalController.toggle();
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
        overlayChildBuilder: (context) {
          return Stack(
            children: [
              // Full-screen transparent barrier to catch taps outside
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _hide,
                child: const SizedBox.expand(),
              ),
              // Positioned popover dropdown directly below the button
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomLeft,
                followerAnchor: Alignment.topLeft,
                offset: const Offset(0, 6),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 156,
                      constraints: const BoxConstraints(maxHeight: 280),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFF3D2DC),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9E1068).withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: widget.options.map((option) {
                              final isSelected =
                                  option == widget.selectedDistance;
                              return InkWell(
                                onTap: () {
                                  widget.onSelected(option);
                                  _hide();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  color: isSelected
                                      ? const Color(0xFFFFF0F5)
                                      : Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        option,
                                        style: TextStyle(
                                          color: isSelected
                                              ? const Color(0xFF9E1068)
                                              : const Color(0xFF5C2337),
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          fontSize: 13.5,
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check_rounded,
                                          color: Color(0xFF9E1068),
                                          size: 16,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: widget.builder(context, _portalController.isShowing, _toggle),
      ),
    );
  }
}
