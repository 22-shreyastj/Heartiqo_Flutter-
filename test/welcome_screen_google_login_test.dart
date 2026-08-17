import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heartiqo_user/features/authentication/controller/social_auth_controller.dart';
import 'package:heartiqo_user/features/authentication/presentation/screens/welcome_screen.dart';

class FakeSocialAuthController extends SocialAuthController {
  bool googleLoginCalled = false;

  @override
  Future<bool> googleLogin(BuildContext context) async {
    googleLoginCalled = true;
    return true;
  }
}

void main() {
  testWidgets('tapping Google login calls the social auth controller', (
    WidgetTester tester,
  ) async {
    final controller = FakeSocialAuthController();

    await tester.pumpWidget(
      MaterialApp(
        home: WelcomeScreen(authController: controller),
      ),
    );

    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();

    expect(controller.googleLoginCalled, isTrue);
  });
}
