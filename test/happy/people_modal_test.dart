import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// WIDGET IMPORT
import 'package:week7_networking_discussion/components/modal.dart';

void main() {
  group('Alert Dialog for User Pages', () {
    // Act
    // create Test Widget
    final testWidget = MaterialApp(
        home: Scaffold(
            body: Builder(
      builder: (BuildContext context) => TextButton(
          onPressed: () {
            // Call Dialog
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmModal(
                      title: "Unfriend @RTegrado",
                      modalBody:
                          "Are you sure that you want to unfriend Renz Tegrado?",
                      confirm: () => print("WAS CLICKED"),
                      passive: true);
                });
          },
          child: const Text("Show Modal")),
    )));

    testWidgets("should appear when a button is clicked.", (tester) async {
      // build the widget
      await tester.pumpWidget(testWidget);

      final button = find.byType(TextButton);

      // make the dialog appear
      await tester.tap(button);
      await tester.pump();

      // assert
      final dialog = find.byType(AlertDialog);
      expect(dialog, findsOneWidget);
    });

    testWidgets("should display correct number of text widgets.",
        (tester) async {
      // build the widget
      await tester.pumpWidget(testWidget);

      final button = find.byType(TextButton);

      // make the dialog appear
      await tester.tap(button);
      await tester.pump();

      final textMessages = find.byType(Text);
      // check if we have correct number of text displays
      expect(textMessages, findsNWidgets(5));
      // FIVE TEXT WIDGETS INCLUDING THE SHOW MODAL TEXT BUTTON
    });

    testWidgets("should display correct display messages.", (tester) async {
      // build the widget
      await tester.pumpWidget(testWidget);

      final button = find.byType(TextButton);

      // make the dialog appear
      await tester.tap(button);
      await tester.pump();

      final titleMessage = find.text("Unfriend @RTegrado");
      // check if we have one title message
      expect(titleMessage, findsOneWidget);

      final contentMessage =
          find.text("Are you sure that you want to unfriend Renz Tegrado?");
      // check if we have one title message
      expect(contentMessage, findsOneWidget);
    });

    testWidgets("should close when the close button was clicked.",
        (tester) async {
      // build the widget
      await tester.pumpWidget(testWidget);

      final button = find.byType(TextButton);

      // make the dialog appear
      await tester.tap(button);
      await tester.pump();

      final closeButton = find.text("No");
      // check if we have a button
      expect(closeButton, findsOneWidget);

      // press close button
      await tester.tap(closeButton);
      await tester.pump();

      // assert
      final dialog = find.byType(AlertDialog);
      expect(dialog, findsNothing);
    });
  });
}
