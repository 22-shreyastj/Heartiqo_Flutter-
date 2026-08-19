import 'package:flutter/material.dart';

class DiscoverFilterState {
  final String genderPreference;
  final RangeValues ageRange;
  final String? relationshipGoal;
  final bool verifiedOnly;
  final bool onlineRecentlyOnly;
  final bool hasPhotoOnly;

  const DiscoverFilterState({
    this.genderPreference = 'Everyone',
    this.ageRange = const RangeValues(18, 50),
    this.relationshipGoal,
    this.verifiedOnly = false,
    this.onlineRecentlyOnly = false,
    this.hasPhotoOnly = false,
  });

  DiscoverFilterState copyWith({
    String? genderPreference,
    RangeValues? ageRange,
    String? relationshipGoal,
    bool clearRelationshipGoal = false,
    bool? verifiedOnly,
    bool? onlineRecentlyOnly,
    bool? hasPhotoOnly,
  }) {
    return DiscoverFilterState(
      genderPreference: genderPreference ?? this.genderPreference,
      ageRange: ageRange ?? this.ageRange,
      relationshipGoal: clearRelationshipGoal
          ? null
          : (relationshipGoal ?? this.relationshipGoal),
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      onlineRecentlyOnly: onlineRecentlyOnly ?? this.onlineRecentlyOnly,
      hasPhotoOnly: hasPhotoOnly ?? this.hasPhotoOnly,
    );
  }
}
