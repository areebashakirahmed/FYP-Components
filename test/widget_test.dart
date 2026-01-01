// Basic Flutter widget test for Mehfilista app.
//
// This test verifies that the app can build and launch successfully.

import 'package:flutter_test/flutter_test.dart';

import 'package:mehfilista/myapp.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyMainApp());

    // Verify the app has loaded (splash screen shows)
    await tester.pump();

    // Basic test to ensure the app builds without crashing
    expect(find.byType(MyMainApp), findsOneWidget);
  });
}
