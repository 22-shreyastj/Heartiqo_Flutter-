import 'package:flutter/material.dart';
import '../model/profile_model.dart';
import '../service/mock_profile_api.dart';
import '../../settings/model/discovery_settings_model.dart';
import '../../settings/service/mock_discovery_api.dart';
import '../../subscription/service/mock_subscription_api.dart';
import '../../authentication/service/mock_auth_api.dart';

class ProfileController extends ChangeNotifier {
  late ProfileModel _profile;
  DiscoverySettingsModel _discoverySettings = const DiscoverySettingsModel();
  bool _isLoading = false;
  String? _errorMessage;

  ProfileController({ProfileModel? initialProfile}) {
    _profile = initialProfile ??
        const ProfileModel(
          name: 'Alex Morgan',
          age: 28,
          occupation: 'Creative Director in New York',
          avatarUrl: 'assets/images/profiles/image1.jpg',
          photos: [
            'assets/images/profiles/image1.jpg',
          ],
          likesCount: 245,
          matchesCount: 32,
          viewsCount: '1.2k',
          bio: 'Designer by day, coffee enthusiast by night. Always down for spontaneous road trips, hidden art galleries, and testing local dessert spots! ✨',
          jobTitle: 'Product Designer',
          education: 'University of Design',
          gender: 'Woman',
          location: 'San Francisco, CA',
          email: 'alex.morgan@example.com',
          phoneNumber: '+1 (555) 234-5678',
          dob: '1996-05-15',
          subscriptionPlan: 'Free',
          isPremium: false,
          selectedInterests: ['Art', 'Foodie', 'Travel'],
          availableInterests: [
            'Fitness',
            'Gaming',
            'Yoga',
            'Cooking',
            'Movies',
            'Music',
          ],
        );
    _loadInitialData();
  }

  ProfileModel get profile => _profile;
  DiscoverySettingsModel get discoverySettings => _discoverySettings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _loadInitialData() async {
    try {
      _isLoading = true;
      notifyListeners();
      final loadedSettings = await MockDiscoveryApi.getDiscoverySettings();
      _discoverySettings = loadedSettings;
    } catch (e) {
      _errorMessage = 'Failed to load initial settings';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateAccountDetails({
    required String name,
    required String email,
    required String phoneNumber,
    required String dob,
    required String gender,
    required String bio,
    required String location,
    String? avatarUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = _profile.copyWith(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        dob: dob,
        gender: gender,
        bio: bio,
        location: location,
        avatarUrl: avatarUrl ?? _profile.avatarUrl,
      );
      final saved = await MockProfileApi.updateProfile(updated);
      _profile = saved;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to save profile details';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> upgradeSubscription(String planName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await MockSubscriptionApi.selectPlan(planName.toLowerCase());
      final isPrem = planName != 'Free';
      _profile = _profile.copyWith(
        subscriptionPlan: planName,
        isPremium: isPrem,
      );
      await MockProfileApi.updateProfile(_profile);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to process subscription upgrade';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateDiscoverySettings(DiscoverySettingsModel settings) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await MockDiscoveryApi.updateDiscoverySettings(settings);
      _discoverySettings = settings;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update discovery settings';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await MockAuthApi.logout();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void updateBio(String bio) {
    _profile = _profile.copyWith(bio: bio);
    notifyListeners();
  }

  void updateJobTitle(String jobTitle) {
    _profile = _profile.copyWith(jobTitle: jobTitle);
    notifyListeners();
  }

  void updateEducation(String education) {
    _profile = _profile.copyWith(education: education);
    notifyListeners();
  }

  void updateGender(String gender) {
    _profile = _profile.copyWith(gender: gender);
    notifyListeners();
  }

  void updateLocation(String location) {
    _profile = _profile.copyWith(location: location);
    notifyListeners();
  }

  void toggleInterest(String interest) {
    final selected = List<String>.from(_profile.selectedInterests);
    final available = List<String>.from(_profile.availableInterests);

    if (selected.contains(interest)) {
      selected.remove(interest);
      if (!available.contains(interest)) {
        available.add(interest);
      }
    } else {
      if (available.contains(interest)) {
        available.remove(interest);
      }
      selected.add(interest);
    }

    _profile = _profile.copyWith(
      selectedInterests: selected,
      availableInterests: available,
    );
    notifyListeners();
  }

  void addCustomInterest(String interest) {
    final trimmed = interest.trim();
    if (trimmed.isEmpty) return;

    final selected = List<String>.from(_profile.selectedInterests);
    if (!selected.contains(trimmed)) {
      selected.add(trimmed);
      _profile = _profile.copyWith(selectedInterests: selected);
      notifyListeners();
    }
  }

  void addPhoto(String photoPath) {
    final updatedPhotos = List<String>.from(_profile.photos);
    if (updatedPhotos.length < 6) {
      updatedPhotos.add(photoPath);
      _profile = _profile.copyWith(photos: updatedPhotos);
      notifyListeners();
    }
  }

  void removePhoto(int index) {
    final updatedPhotos = List<String>.from(_profile.photos);
    if (index >= 0 && index < updatedPhotos.length) {
      updatedPhotos.removeAt(index);
      _profile = _profile.copyWith(photos: updatedPhotos);
      notifyListeners();
    }
  }

  void generateAiBio() {
    const aiBios = [
      "Designer by day, coffee enthusiast by night. Always down for spontaneous road trips, hidden art galleries, and testing local dessert spots! ✨",
      "Passionate about creating beautiful experiences, exploring nature, and discovering acoustic live music. Let's exchange favorite travel stories! 🌍🎵",
      "Living life one espresso shot at a time. Big fan of design, indie cinema, and home-cooked dinners with friends. ☕🎨",
    ];
    final selectedBio = (aiBios..shuffle()).first;
    _profile = _profile.copyWith(bio: selectedBio);
    notifyListeners();
  }

  void saveProfile() {
    MockProfileApi.updateProfile(_profile);
    notifyListeners();
  }
}
