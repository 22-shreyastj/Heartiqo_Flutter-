import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heartiqo_user/home_page.dart';
import 'package:heartiqo_user/swipe_profile_page.dart';

void main() {
  testWidgets('SwipeProfilePage displays profile 1 and transitions on button press',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SwipeProfilePage(),
      ),
    );

    // Verify initial profile (Sophia, 26) is rendered
    expect(find.text('Sophia, 26'), findsWidgets);
    expect(find.text('4 km away'), findsWidgets);
    expect(find.text('96% Match Compatibility'), findsWidgets);
    expect(find.text('Travel'), findsWidgets);

    // Tap Pass/Reject button (X icon)
    final passButton = find.byKey(const ValueKey('swipe_pass_btn'));
    if (passButton.evaluate().isNotEmpty) {
      await tester.tap(passButton);
    } else {
      await tester.tap(find.byIcon(Icons.close_rounded).first);
    }

    await tester.pumpAndSettle();

    // Verify next profile (Emma, 25) is now displayed
    expect(find.text('Emma, 25'), findsWidgets);
    expect(find.text('6 km away'), findsWidgets);
    expect(find.text('92% Match Compatibility'), findsWidgets);
  });

  testWidgets('HomePage displays Tinder-style swipeable card and responds to actions',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    // Verify initial profile card (Sophia, 26) is rendered on HomePage
    expect(find.text('Sophia, 26'), findsWidgets);
    expect(find.text('4 km away'), findsWidgets);

    // Tap the reject button on HomePage
    await tester.tap(find.byIcon(Icons.close_rounded).first, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Verify next profile card (Emma, 25) appears on HomePage
    expect(find.text('Emma, 25'), findsWidgets);
    expect(find.text('6 km away'), findsWidgets);
  });
}
