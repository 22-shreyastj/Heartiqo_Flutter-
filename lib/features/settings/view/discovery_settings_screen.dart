import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../profile/controller/profile_controller.dart';
import '../model/discovery_settings_model.dart';
import '../service/mock_discovery_api.dart';

class DiscoverySettingsScreen extends StatefulWidget {
  final ProfileController? controller;

  const DiscoverySettingsScreen({super.key, this.controller});

  @override
  State<DiscoverySettingsScreen> createState() =>
      _DiscoverySettingsScreenState();
}

class _DiscoverySettingsScreenState extends State<DiscoverySettingsScreen> {
  late String _preferredGender;
  late RangeValues _ageRange;
  late double _maxDistance;
  late bool _showMeOnApp;
  late bool _globalMode;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.controller?.discoverySettings ??
        const DiscoverySettingsModel();
    _preferredGender = initial.preferredGender;
    _ageRange = RangeValues(
        initial.minAge.toDouble(), initial.maxAge.toDouble());
    _maxDistance = initial.maxDistance;
    _showMeOnApp = initial.showMeOnApp;
    _globalMode = initial.globalMode;
  }

  Future<void> _handleSave() async {
    setState(() {
      _isSaving = true;
    });

    final updated = DiscoverySettingsModel(
      preferredGender: _preferredGender,
      minAge: _ageRange.start.round(),
      maxAge: _ageRange.end.round(),
      maxDistance: _maxDistance,
      showMeOnApp: _showMeOnApp,
      globalMode: _globalMode,
    );

    bool success = false;
    if (widget.controller != null) {
      success = await widget.controller!.updateDiscoverySettings(updated);
    } else {
      success = await MockDiscoveryApi.updateDiscoverySettings(updated);
    }

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Discovery settings updated'),
          backgroundColor: AppColors.brandPink,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update discovery settings'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Discovery Settings',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container 1: Preferences
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Interested In',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: ['Women', 'Men', 'Everyone'].map((gender) {
                      final isSelected = _preferredGender == gender;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: SizedBox(
                              width: double.infinity,
                              child: Text(
                                gender,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textDark,
                                ),
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.brandPink,
                            backgroundColor: AppColors.softPinkSlot,
                            onSelected: (val) {
                              if (val) {
                                setState(() {
                                  _preferredGender = gender;
                                });
                              }
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const Divider(height: 32, color: AppColors.borderLight),

                  // Age Range Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Age Range',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        '${_ageRange.start.round()} - ${_ageRange.end.round()} yrs',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.brandPink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: _ageRange,
                    min: 18,
                    max: 70,
                    divisions: 52,
                    activeColor: AppColors.brandPink,
                    inactiveColor: AppColors.softPinkSlot,
                    labels: RangeLabels(
                      _ageRange.start.round().toString(),
                      _ageRange.end.round().toString(),
                    ),
                    onChanged: (values) {
                      setState(() {
                        _ageRange = values;
                      });
                    },
                  ),

                  const Divider(height: 32, color: AppColors.borderLight),

                  // Distance Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Maximum Distance',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        '${_maxDistance.round()} km',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.brandPink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _maxDistance,
                    min: 1,
                    max: 100,
                    divisions: 99,
                    activeColor: AppColors.brandPink,
                    inactiveColor: AppColors.softPinkSlot,
                    label: '${_maxDistance.round()} km',
                    onChanged: (val) {
                      setState(() {
                        _maxDistance = val;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Container 2: Visibility & Global mode
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text(
                      'Show me on Heartiqo',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    subtitle: const Text(
                      'Turn off to hide your profile while retaining matches',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    value: _showMeOnApp,
                    activeColor: AppColors.brandPink,
                    onChanged: (val) {
                      setState(() {
                        _showMeOnApp = val;
                      });
                    },
                  ),
                  const Divider(height: 1, color: AppColors.borderLight),
                  SwitchListTile(
                    title: const Text(
                      'Global Passport Mode',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    subtitle: const Text(
                      'Match with single people around the world',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    value: _globalMode,
                    activeColor: AppColors.brandPink,
                    onChanged: (val) {
                      setState(() {
                        _globalMode = val;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 2,
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Discovery Settings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
