class MockAuthApi {
  static bool _isLoggedIn = true;

  static bool get isLoggedIn => _isLoggedIn;

  static Future<bool> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoggedIn = false;
    return true;
  }

  static Future<bool> checkSession() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _isLoggedIn;
  }
}
