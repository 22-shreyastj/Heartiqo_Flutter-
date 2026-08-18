import 'package:flutter/material.dart';
import '../model/profile_model.dart';

class ProfileController extends ChangeNotifier {
  late ProfileModel _profile;

  ProfileController({ProfileModel? initialProfile}) {
    _profile = initialProfile ??
        const ProfileModel(
          name: 'Alex',
          age: 28,
          occupation: 'Creative Director in New York',
          avatarUrl: 'assets/images/profiles/image1.jpg',
          photos: [
            'assets/images/profiles/image1.jpg',
          ],
          likesCount: 245,
          matchesCount: 32,
          viewsCount: '1.2k',
          bio: '',
          jobTitle: 'Product Designer',
          education: 'University of Design',
          gender: 'Woman',
          location: 'San Francisco, CA',
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
  }

  ProfileModel get profile => _profile;

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
    // Save logic / Network call persistence
    notifyListeners();
  }
}
