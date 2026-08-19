import 'package:flutter/material.dart';

class DiscoverInterestDropdown extends StatefulWidget {
  final Set<String> selectedInterests;
  final List<String> options;
  final ValueChanged<Set<String>> onApplied;
  final Widget Function(BuildContext context, bool isOpen, VoidCallback toggle)
  builder;

  const DiscoverInterestDropdown({
    super.key,
    required this.selectedInterests,
    required this.options,
    required this.onApplied,
    required this.builder,
  });

  @override
  State<DiscoverInterestDropdown> createState() =>
      _DiscoverInterestDropdownState();
}

class _DiscoverInterestDropdownState extends State<DiscoverInterestDropdown> {
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _portalController = OverlayPortalController();
  final Set<String> _tempSelected = {};

  void _toggle() {
    if (_portalController.isShowing) {
      _hide();
    } else {
      _show();
    }
  }

  void _show() {
    _tempSelected.clear();
    _tempSelected.addAll(widget.selectedInterests);
    _portalController.show();
    setState(() {});
  }

  void _hide() {
    if (_portalController.isShowing) {
      _portalController.hide();
      setState(() {});
    }
  }

  void _toggleOption(String option) {
    if (_tempSelected.contains(option)) {
      _tempSelected.remove(option);
    } else {
      _tempSelected.add(option);
    }
    setState(() {});
  }

  void _clearAll() {
    _tempSelected.clear();
    setState(() {});
  }

  void _apply() {
    widget.onApplied(Set<String>.from(_tempSelected));
    _hide();
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
              // Transparent barrier to dismiss popover when tapping outside
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _hide,
                child: const SizedBox.expand(),
              ),
              // Positioned popover dropdown directly below the Interests button
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomRight,
                followerAnchor: Alignment.topRight,
                offset: const Offset(0, 6),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 195,
                      constraints: BoxConstraints(
                        maxHeight: 340,
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
                            color: const Color(0xFF9E1068).withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Scrollable list of interest options
                            Flexible(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: widget.options.map((option) {
                                    final isSelected = _tempSelected.contains(
                                      option,
                                    );
                                    return InkWell(
                                      onTap: () => _toggleOption(option),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 9,
                                        ),
                                        color: isSelected
                                            ? const Color(0xFFFFF0F5)
                                            : Colors.transparent,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
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
                                            ),
                                            Container(
                                              width: 18,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isSelected
                                                    ? const Color(0xFF9E1068)
                                                    : Colors.transparent,
                                                border: Border.all(
                                                  color: isSelected
                                                      ? const Color(0xFF9E1068)
                                                      : const Color(0xFFD6A0B3),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: isSelected
                                                  ? const Icon(
                                                      Icons.check_rounded,
                                                      color: Colors.white,
                                                      size: 12,
                                                    )
                                                  : null,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),

                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF3D2DC),
                            ),

                            // Footer bar with Clear and Apply buttons
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: _tempSelected.isEmpty
                                        ? null
                                        : _clearAll,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'Clear',
                                      style: TextStyle(
                                        color: _tempSelected.isEmpty
                                            ? const Color(0xFFBCA6B0)
                                            : const Color(0xFF8A0B3B),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _apply,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF9E1068),
                                            Color(0xFFC41C70),
                                          ],
                                        ),
                                      ),
                                      child: const Text(
                                        'Apply',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
