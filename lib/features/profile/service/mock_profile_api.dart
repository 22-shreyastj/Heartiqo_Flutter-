import '../model/profile_model.dart';

class MockProfileApi {
  static ProfileModel _mockProfile = const ProfileModel(
    id: '1',
    name: 'Alex Morgan',
    age: 28,
    occupation: 'Creative Director in New York',
    avatarUrl: 'assets/images/profiles/image1.jpg',
    photos: ['assets/images/profiles/image1.jpg'],
    likesCount: 245,
    matchesCount: 32,
    viewsCount: '1.2k',
    bio: 'Designer by day, coffee lover by night. Always looking for new food spots and travel partners.',
    jobTitle: 'Product Designer',
    education: 'University of Design',
    gender: 'Woman',
    location: 'San Francisco, CA',
    email: 'alex.morgan@example.com',
    phoneNumber: '+1 (555) 234-5678',
    dob: '1996-05-15',
    subscriptionPlan: 'Free',
    isPremium: false,
  );

  static Future<ProfileModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockProfile;
  }

  static Future<ProfileModel> updateProfile(ProfileModel updated) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _mockProfile = updated;
    return _mockProfile;
  }
}
