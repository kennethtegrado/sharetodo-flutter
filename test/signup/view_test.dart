import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week7_networking_discussion/main.dart' as app;

void main() {
  group("signup page", () {
    testWidgets('should have complete widgets', (tester) async {
      app.testMain();

      final signUpButton = find.byKey(const Key("signUpButton"));

      await tester.tap(signUpButton);

      final signupDisplay = find.text("Sign Up");

      final createAccountButton = find.byKey(const Key("signUpButton"));
      final backButton = find.text('Back');

      expect(signupDisplay, findsOneWidget);

      expect(createAccountButton, findsOneWidget);
      expect(backButton, findsOneWidget);
    });

    testWidgets('should have complete form fields', (tester) async {
      app.testMain();

      final signUpButton = find.byKey(const Key("signUpButton"));

      await tester.tap(signUpButton);

      final emailField = find.byKey(const Key("emailField"));
      final passwordField = find.byKey(const Key("passwordField"));
      final firstNameField = find.byKey(const Key("firstNameField"));
      final lastNameField = find.byKey(const Key("lastNameField"));
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(firstNameField, findsOneWidget);
      expect(lastNameField, findsOneWidget);
    });
  });
}
