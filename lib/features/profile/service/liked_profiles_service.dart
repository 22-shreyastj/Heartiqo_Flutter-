import 'package:flutter/foundation.dart';
import '../model/profile_model.dart';

class LikedProfilesService extends ValueNotifier<List<ProfileModel>> {
  static final LikedProfilesService instance = LikedProfilesService._internal();

  LikedProfilesService._internal() : super([]);

  List<ProfileModel> get likedProfiles => value;

  bool isLiked(ProfileModel profile) {
    return value.any((p) => p.name == profile.name);
  }

  void addLikedProfile(ProfileModel profile) {
    if (!isLiked(profile)) {
      value = [...value, profile];
    }
  }

  void removeLikedProfile(ProfileModel profile) {
    value = value.where((p) => p.name != profile.name).toList();
  }
}
