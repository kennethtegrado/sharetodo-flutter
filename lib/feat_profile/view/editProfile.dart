/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo/index.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';

class EditModal extends StatelessWidget {
  String type;
  String id;
  String? bio;
  String? birthday;
  String? location;
  String? helperText;
  final _formKey = GlobalKey<FormState>();
  // int todoIndex;
  TextEditingController _formFieldController = TextEditingController();

  EditModal(
      {super.key,
      required this.type,
      required this.id,
      this.location,
      this.birthday,
      this.bio})
      : helperText =
            type == "birthday" ? "Format must be in YYYY-MM-DD." : null;

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'bio':
        return const Text("Add some changes to your bio.");
      case 'location':
        return const Text("Edit your location.");
      case 'birthday':
        return const Text("Edit your birthday");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    // Use context.read to get the last updated list of todos
    // List<Todo> todoItems = context.read<TodoListProvider>().todo;

    return TextFormField(
      controller: _formFieldController,
      decoration: InputDecoration(
          border: const OutlineInputBorder(), helperText: helperText),
    );
  }

  TextButton _dialogAction(BuildContext context) {
    if (type == "birthday") {}
    // List<Todo> todoItems = context.read<TodoListProvider>().todo;
    return TextButton(
      onPressed: () {
        switch (type) {
          case 'bio':
            {
              context
                  .read<AuthProvider>()
                  .updateBio(userID: id, bio: _formFieldController.text);

              // Remove dialog after adding
              Navigator.of(context).pop();
              break;
            }
          case 'location':
            {
              context.read<AuthProvider>().updateLocation(
                  userID: id, location: _formFieldController.text);

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'birthday':
            {
              context.read<AuthProvider>().updateBirthday(
                  userID: id, birthday: _formFieldController.text);

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: const Text("Submit"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
