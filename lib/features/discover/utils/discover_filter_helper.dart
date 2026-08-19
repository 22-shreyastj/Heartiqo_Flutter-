import '../model/discover_filter_state.dart';
import '../model/discover_profile.dart';

class DiscoverFilterHelper {
  static double? parseDistanceInMiles(String value) {
    final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(value);
    if (match == null) return null;
    return double.tryParse(match.group(1)!);
  }

  static double? maxDistanceInMiles(String selectedDistance) {
    if (selectedDistance == 'Distance' || selectedDistance == 'Any distance') {
      return null;
    }
    return parseDistanceInMiles(selectedDistance);
  }

  static bool matchesDistance(DiscoverProfile profile, double? maxMiles) {
    if (maxMiles == null) return true;
    final profileMiles = parseDistanceInMiles(profile.distance);
    if (profileMiles == null) return true;
    return profileMiles <= maxMiles;
  }

  static bool matchesRelationshipGoal(
    DiscoverProfile profile,
    String? relationshipGoal,
  ) {
    if (relationshipGoal == null) return true;

    final profileGoal = profile.relationshipGoal?.trim().toLowerCase() ?? '';

    switch (relationshipGoal) {
      case 'Long-term':
        return profileGoal.contains('long term') ||
            profileGoal.contains('long-term');
      case 'Short-term':
        return profileGoal.contains('short term') ||
            profileGoal.contains('short-term');
      case 'Friendship':
        return profileGoal.contains('friendship');
      default:
        return true;
    }
  }

  static bool matches({
    required DiscoverProfile profile,
    required String searchQuery,
    required String selectedDistance,
    required Set<String> selectedInterests,
    required DiscoverFilterState filters,
  }) {
    // 1. Search: name OR interests
    final query = searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      final matchesName = profile.name.toLowerCase().contains(query);
      final matchesInterest = profile.interests.any(
        (interest) => interest.toLowerCase().contains(query),
      );
      if (!matchesName && !matchesInterest) {
        return false;
      }
    }

    // 2. Distance
    final maxMiles = maxDistanceInMiles(selectedDistance);
    if (!matchesDistance(profile, maxMiles)) {
      return false;
    }

    // 3. Interests (OR logic: profile must have at least one selected interest)
    if (selectedInterests.isNotEmpty) {
      final matchesInterest = profile.interests.any(
        (profileInterest) => selectedInterests.any(
          (selected) => selected.toLowerCase() == profileInterest.toLowerCase(),
        ),
      );
      if (!matchesInterest) {
        return false;
      }
    }

    // 4. Age
    if (profile.age < filters.ageRange.start ||
        profile.age > filters.ageRange.end) {
      return false;
    }

    // 5. Gender
    if (filters.genderPreference != 'Everyone') {
      final expectedGender = filters.genderPreference == 'Women'
          ? 'female'
          : 'male';
      if (profile.gender.toLowerCase() != expectedGender) {
        return false;
      }
    }

    // 6. Relationship goal
    if (filters.relationshipGoal != null &&
        !matchesRelationshipGoal(profile, filters.relationshipGoal)) {
      return false;
    }

    // 7. Verified only
    if (filters.verifiedOnly && !profile.isVerified) {
      return false;
    }

    // 8. Online recently only
    if (filters.onlineRecentlyOnly && !profile.onlineRecently) {
      return false;
    }

    // 9. Has profile photo only
    if (filters.hasPhotoOnly && !profile.hasPhoto) {
      return false;
    }

    return true;
  }
}
