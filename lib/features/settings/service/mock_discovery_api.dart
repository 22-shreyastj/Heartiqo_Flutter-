import '../model/discovery_settings_model.dart';

class MockDiscoveryApi {
  static DiscoverySettingsModel _settings = const DiscoverySettingsModel();

  static Future<DiscoverySettingsModel> getDiscoverySettings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _settings;
  }

  static Future<bool> updateDiscoverySettings(DiscoverySettingsModel updated) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _settings = updated;
    return true;
  }
}
