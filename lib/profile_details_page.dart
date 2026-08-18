import 'package:flutter/material.dart';
import 'features/profile/data/sample_profiles.dart';
import 'features/profile/model/profile_model.dart';
import 'swipe_profile_page.dart';

class ProfileDetailsPage extends StatelessWidget {
  final ProfileModel? profile;
  final List<ProfileModel>? profiles;
  final int initialIndex;

  const ProfileDetailsPage({
    super.key,
    this.profile,
    this.profiles,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final list = profiles ?? sampleProfiles;
    int idx = initialIndex;
    if (profile != null) {
      final found = list.indexWhere((p) => p.name == profile!.name);
      if (found != -1) {
        idx = found;
      }
    }

    return SwipeProfilePage(
      profiles: list,
      initialIndex: idx,
    );
  }
}
