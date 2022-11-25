import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week7_networking_discussion/main.dart' as app;

void main() {
  group("login page", () {
    testWidgets('should have complete widgets', (tester) async {
      app.testMain();

      final screenDisplay = find.text('Login');
      final userNameField = find.byKey(const Key("emailField"));
      final passwordField = find.byKey(const Key("passwordField"));
      final loginButton = find.byKey(const Key("loginButton"));
      final signUpButton = find.byKey(const Key("signUpButton"));

      expect(screenDisplay, findsOneWidget);
      expect(userNameField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(loginButton, findsOneWidget);
      expect(signUpButton, findsOneWidget);
    });

    testWidgets('should not have a widget with a pwField key', (tester) async {
      app.testMain();

      // random item
      final failedItemFoundField = find.byKey(const Key("pwField"));

      expect(failedItemFoundField, findsNothing);
    });

    testWidgets(
        'should redirect user to signup page when signup button was clicked',
        (tester) async {
      app.testMain();

      final signUpButton = find.byKey(const Key("signUpButton"));

      await tester.tap(signUpButton);

      final signupDisplay = find.text("Sign Up");
      expect(signupDisplay, findsOneWidget);
    });
  });
}
