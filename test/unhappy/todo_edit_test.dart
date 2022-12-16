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

    testWidgets(
        "should display an error text when user submitted an empty title field.",
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

      final inputFormField = find.text("Enter new title.");

      expect(inputFormField, findsOneWidget);

      final editTitleSubmitButton =
          find.byKey(const Key("submitEditTitleButton"));

      expect(editTitleSubmitButton, findsOneWidget);

      await tester.tap(editTitleSubmitButton);
      await tester.pump();

      final errorText = find.text('Please put a title.');

      expect(errorText, findsOneWidget);
    });

    testWidgets(
        "should display an error text when user submitted an empty description field.",
        (tester) async {
      // build the widget
      await tester.pumpWidget(testWidget);

      final button = find.byType(TextButton);

      // make the dialog appear
      await tester.tap(button);
      await tester.pump();

      final editDescriptionButton =
          find.byKey(const Key("descriptionEditButton"));
      // check if we have correct number of text displays
      expect(editDescriptionButton, findsOneWidget);

      // make the dialog appear
      await tester.tap(editDescriptionButton);
      await tester.pump();

      final inputFormField = find.text("Enter new description.");

      expect(inputFormField, findsOneWidget);

      final submitEditDescriptionButton =
          find.byKey(const Key("SubmitDescriptionButton"));

      expect(submitEditDescriptionButton, findsOneWidget);

      await tester.tap(submitEditDescriptionButton);
      await tester.pump();

      final errorText = find.text('Please put a description.');

      expect(errorText, findsOneWidget);
    });

    testWidgets(
        "should display an error text when user submitted an empty deadline field.",
        (tester) async {
      // build the widget
      await tester.pumpWidget(testWidget);

      final button = find.byType(TextButton);

      // make the dialog appear
      await tester.tap(button);
      await tester.pump();

      final editDescriptionButton = find.byKey(const Key("deadlineEditButton"));
      // check if we have correct number of text displays
      expect(editDescriptionButton, findsOneWidget);

      // make the dialog appear
      await tester.tap(editDescriptionButton);
      await tester.pump();

      final inputFormField = find.text("Enter new deadline.");

      expect(inputFormField, findsOneWidget);

      final editTitleSubmitButton =
          find.byKey(const Key("SubmitDeadlineButton"));

      expect(editTitleSubmitButton, findsOneWidget);

      await tester.tap(editTitleSubmitButton);
      await tester.pump();

      final errorText = find.text("Please put a deadline.");

      expect(errorText, findsOneWidget);
    });

    testWidgets(
        "should display an error text when user submitted an invalid date format",
        (tester) async {
      // build the widget
      await tester.pumpWidget(testWidget);

      final button = find.byType(TextButton);

      // make the dialog appear
      await tester.tap(button);
      await tester.pump();

      final editDeadlineButton = find.byKey(const Key("deadlineEditButton"));
      // check if we have correct number of text displays
      expect(editDeadlineButton, findsOneWidget);

      // make the dialog appear
      await tester.tap(editDeadlineButton);
      await tester.pump();

      final inputFormField = find.byKey(const Key("deadlineFormField"));

      expect(inputFormField, findsOneWidget);

      await tester.enterText(inputFormField, '12-02-2022');

      final editTitleSubmitButton =
          find.byKey(const Key("SubmitDeadlineButton"));

      expect(editTitleSubmitButton, findsOneWidget);

      await tester.tap(editTitleSubmitButton);
      await tester.pump();

      final errorText = find.text("Please put a valid deadline!");

      expect(errorText, findsOneWidget);
    });
  });
}
