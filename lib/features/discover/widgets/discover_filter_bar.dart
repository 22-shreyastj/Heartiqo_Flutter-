import 'package:flutter/material.dart';
import '../controller/discover_controller.dart';
import 'discover_distance_dropdown.dart';
import 'discover_interest_dropdown.dart';

class DiscoverFilterBar extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String>? onFilterSelected;
  final String selectedDistance;
  final ValueChanged<String>? onDistanceSelected;
  final List<String> distanceOptions;
  final Set<String> selectedInterests;
  final ValueChanged<Set<String>>? onInterestsSelected;
  final List<String> availableInterests;

  const DiscoverFilterBar({
    super.key,
    this.selectedFilter = 'Filters',
    this.onFilterSelected,
    this.selectedDistance = 'Distance',
    this.onDistanceSelected,
    this.distanceOptions = DiscoverController.distanceOptions,
    this.selectedInterests = const {},
    this.onInterestsSelected,
    this.availableInterests = const [],
  });

  String get _interestsLabel {
    if (selectedInterests.isEmpty) return 'Interests';
    if (selectedInterests.length == 1) return selectedInterests.first;
    return 'Interests (${selectedInterests.length})';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final small = constraints.maxWidth < 350;

          return Row(
            children: [
              // Filters
              Expanded(
                flex: 10,
                child: _PrimaryFilterButton(
                  label: 'Filters',
                  icon: Icons.tune_rounded,
                  isSelected: selectedFilter == 'Filters',
                  compact: small,
                  onTap: () => onFilterSelected?.call('Filters'),
                ),
              ),

              SizedBox(width: small ? 5 : 8),

              // Distance
              Expanded(
                flex: 12,
                child: DiscoverDistanceDropdown(
                  selectedDistance: selectedDistance,
                  options: distanceOptions,
                  onSelected: (distance) {
                    onDistanceSelected?.call(distance);
                  },
                  builder: (context, isOpen, toggle) {
                    return _SecondaryFilterButton(
                      label: selectedDistance,
                      isOpen: isOpen,
                      isSelected:
                          selectedDistance != 'Distance' &&
                          selectedDistance != 'Any distance',
                      compact: small,
                      onTap: toggle,
                    );
                  },
                ),
              ),

              SizedBox(width: small ? 5 : 8),

              // Interests
              Expanded(
                flex: 13,
                child: DiscoverInterestDropdown(
                  selectedInterests: selectedInterests,
                  options: availableInterests,
                  onApplied: (interests) {
                    onInterestsSelected?.call(interests);
                  },
                  builder: (context, isOpen, toggle) {
                    return _SecondaryFilterButton(
                      label: _interestsLabel,
                      isOpen: isOpen,
                      isSelected: selectedInterests.isNotEmpty,
                      compact: small,
                      onTap: toggle,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Primary Filter Button
// -----------------------------------------------------------------------------

class _PrimaryFilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool compact;
  final VoidCallback onTap;

  const _PrimaryFilterButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.compact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 44,
          padding: EdgeInsets.symmetric(horizontal: compact ? 7 : 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [Color(0xFF9E1068), Color(0xFFC41C70)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9E1068).withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: compact ? 15 : 17),
              SizedBox(width: compact ? 3 : 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: compact ? 12 : 13.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Distance / Interests Button
// -----------------------------------------------------------------------------

class _SecondaryFilterButton extends StatelessWidget {
  final String label;
  final bool isOpen;
  final bool isSelected;
  final bool compact;
  final VoidCallback onTap;

  const _SecondaryFilterButton({
    required this.label,
    required this.isOpen,
    required this.isSelected,
    required this.compact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? const Color(0xFF9E1068)
        : const Color(0xFF8A0B3B);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 44,
          padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 9),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFF0F5) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFC41C70)
                  : const Color(0xFFF3D2DC),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: compact ? 12 : 13.5,
                  ),
                ),
              ),

              SizedBox(width: compact ? 1 : 3),

              Icon(
                isOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: color,
                size: compact ? 16 : 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
