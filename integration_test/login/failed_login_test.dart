import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:week7_networking_discussion/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('failed login test', () {
    testWidgets('Test failed', (tester) async {
      app.testMain();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));
    });
  });
}
