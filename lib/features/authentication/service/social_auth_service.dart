import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SocialAuthService {
  final GoogleSignIn googleSignIn =
      GoogleSignIn.instance;

  Future<void> initializeGoogle({String? serverClientId}) async {
    await googleSignIn.initialize(
      serverClientId:
          serverClientId != null && serverClientId.isNotEmpty
              ? serverClientId
              : null,
    );
  }

  Future<GoogleSignInAccount?> loginWithGoogle() async {
    try {
      final user =
          await googleSignIn.authenticate();

      return user;
    } catch (e) {
      print('Google Login Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> loginWithFacebook() async {
    try {
      final LoginResult result =
          await FacebookAuth.instance.login(
        permissions: [
          'email',
          'public_profile',
        ],
      );

      if (result.status == LoginStatus.success) {
        final userData =
            await FacebookAuth.instance.getUserData();

        return userData;
      }

      print(
        'Facebook Login Status: ${result.status}',
      );

      return null;
    } catch (e) {
      print('Facebook Login Error: $e');
      return null;
    }
  }

  Future<void> logoutGoogle() async {
    await googleSignIn.signOut();
  }

  Future<void> logoutFacebook() async {
    await FacebookAuth.instance.logOut();
  }
}