import '../model/safety_model.dart';

class MockSafetyApi {
  static List<BlockedUserModel> _blockedUsers = [
    const BlockedUserModel(
      id: 'b1',
      name: 'John Doe',
      avatarUrl: 'assets/images/profiles/image2.jpg',
      blockedDate: '2026-07-12',
      reason: 'Inappropriate Messages',
    ),
    const BlockedUserModel(
      id: 'b2',
      name: 'User 9842',
      avatarUrl: 'assets/images/profiles/image3.jpg',
      blockedDate: '2026-08-01',
      reason: 'Spam / Fake Account',
    ),
  ];

  static PrivacySettingsModel _privacySettings = const PrivacySettingsModel();

  static Future<List<BlockedUserModel>> getBlockedUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_blockedUsers);
  }

  static Future<bool> unblockUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _blockedUsers.removeWhere((u) => u.id == userId);
    return true;
  }

  static Future<bool> submitReport(UserReportModel report) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return true;
  }

  static Future<PrivacySettingsModel> getPrivacySettings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _privacySettings;
  }

  static Future<bool> updatePrivacySettings(PrivacySettingsModel settings) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _privacySettings = settings;
    return true;
  }
}
