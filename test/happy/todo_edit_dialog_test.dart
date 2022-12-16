import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// WIDGET IMPORT
import 'package:week7_networking_discussion/feat_todo/view/edit_dialog.dart';

import 'package:week7_networking_discussion/models/todo/index.dart';

void main() {
  group('Todo Edit Dialog', () {
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
                  Todo todo = Todo(
                      createdBy: "randomthings",
                      title: "Testing Todo",
                      completed: false,
                      dateCreated: DateTime.now(),
                      deadline: DateTime.parse("2024-12-19"),
                      description:
                          "This is just me testing the capability of flutter when it comes to widget testing.",
                      author: "Renz Tegrado");
                  return EditDialog(todo: todo, userName: "Renz Tegrado");
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

    testWidgets(
        "should display an alert dialog for editing title when edit title was clicked.",
        (tester) async {
      // build the widget
      await tester.pumpWidget(testWidget);

      final button = find.byType(TextButton);

      // make the dialog appear
      await tester.tap(button);
      await tester.pump();

      final editTitleButton = find.byKey(const Key("EditTitleButton"));
      // check if we have correct number of text displays
      expect(editTitleButton, findsOneWidget);

      // make the dialog appear
      await tester.tap(editTitleButton);
      await tester.pump();

      final inputFormField = find.byKey(const Key("EditTitleField"));

      expect(inputFormField, findsOneWidget);
    });
  });
}
