import 'package:flutter/material.dart';
import '../controller/discover_controller.dart';

class DiscoverAdvancedFilterScreen extends StatefulWidget {
  final DiscoverController controller;

  const DiscoverAdvancedFilterScreen({super.key, required this.controller});

  @override
  State<DiscoverAdvancedFilterScreen> createState() =>
      _DiscoverAdvancedFilterScreenState();
}

class _DiscoverAdvancedFilterScreenState
    extends State<DiscoverAdvancedFilterScreen> {
  late String _gender;
  late RangeValues _ageRange;
  String? _relationshipGoal;

  late bool _verifiedOnly;
  late bool _onlineRecently;
  late bool _hasPhoto;

  static const _primary = Color(0xFF9E1068);
  static const _secondary = Color(0xFFC41C70);
  static const _border = Color(0xFFF3D2DC);
  static const _background = Color(0xFFFFF8F8);

  @override
  void initState() {
    super.initState();

    final controller = widget.controller;

    _gender = controller.genderPreference;
    _ageRange = controller.ageRange;
    _relationshipGoal = controller.relationshipGoal;

    _verifiedOnly = controller.verifiedOnly;
    _onlineRecently = controller.onlineRecentlyOnly;
    _hasPhoto = controller.hasPhotoOnly;
  }

  void _applyFilters() {
    widget.controller
      ..setGenderPreference(_gender)
      ..setAgeRange(_ageRange)
      ..setRelationshipGoal(_relationshipGoal)
      ..setVerifiedOnly(_verifiedOnly)
      ..setOnlineRecentlyOnly(_onlineRecently)
      ..setHasPhotoOnly(_hasPhoto);

    Navigator.pop(context);
  }

  void _resetFilters() {
    widget.controller.resetAdvancedFilters();

    setState(() {
      _gender = 'Everyone';
      _ageRange = const RangeValues(18, 50);
      _relationshipGoal = null;
      _verifiedOnly = false;
      _onlineRecently = false;
      _hasPhoto = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _background,
        foregroundColor: _primary,
        centerTitle: true,
        title: const Text(
          'Filters',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            color: _primary,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gender
                    const _SectionTitle('Who do you want to meet?'),
                    const SizedBox(height: 12),

                    Row(
                      children: DiscoverController.genderOptions.map((item) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: _SelectionButton(
                              label: item,
                              selected: _gender == item,
                              onTap: () {
                                setState(() {
                                  _gender = item;
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),

                    // Age
                    Row(
                      children: [
                        const Expanded(child: _SectionTitle('Age range')),
                        Text(
                          '${_ageRange.start.round()} - '
                          '${_ageRange.end.round()}',
                          style: const TextStyle(
                            color: _primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    RangeSlider(
                      values: _ageRange,
                      min: 18,
                      max: 70,
                      divisions: 52,
                      activeColor: _secondary,
                      inactiveColor: _border,
                      labels: RangeLabels(
                        '${_ageRange.start.round()}',
                        '${_ageRange.end.round()}',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _ageRange = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Relationship Goal
                    const _SectionTitle('Relationship goal'),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: DiscoverController.relationshipGoalOptions.map((
                        goal,
                      ) {
                        return _SelectionButton(
                          label: goal,
                          selected: _relationshipGoal == goal,
                          onTap: () {
                            setState(() {
                              if (_relationshipGoal == goal) {
                                _relationshipGoal = null;
                              } else {
                                _relationshipGoal = goal;
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),

                    // Profile Preferences
                    const _SectionTitle('Profile preferences'),
                    const SizedBox(height: 8),

                    _FilterSwitch(
                      title: 'Verified profiles only',
                      subtitle: 'Show only verified profiles',
                      value: _verifiedOnly,
                      onChanged: (value) {
                        setState(() {
                          _verifiedOnly = value;
                        });
                      },
                    ),

                    _FilterSwitch(
                      title: 'Online recently',
                      subtitle: 'People who were recently active',
                      value: _onlineRecently,
                      onChanged: (value) {
                        setState(() {
                          _onlineRecently = value;
                        });
                      },
                    ),

                    _FilterSwitch(
                      title: 'Has profile photo',
                      subtitle: 'Show profiles with a photo',
                      value: _hasPhoto,
                      onChanged: (value) {
                        setState(() {
                          _hasPhoto = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 15,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetFilters,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        foregroundColor: _primary,
                        side: const BorderSide(color: _secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: _primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Reusable local components
// -----------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF351620),
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _SelectionButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SelectionButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF9E1068) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected
                  ? const Color(0xFF9E1068)
                  : const Color(0xFFF3D2DC),
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF8A0B3B),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _FilterSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      activeColor: const Color(0xFF9E1068),
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF351620),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color(0xFF8B727A), fontSize: 12.5),
      ),
    );
  }
}
