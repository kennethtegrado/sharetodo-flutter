import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/config/theme/index.dart';
import 'package:provider/provider.dart';

// model import
import '../../models/todo/index.dart';

// package provider
import 'package:week7_networking_discussion/providers/todo_provider.dart';

class EditDialog extends StatelessWidget {
  late Todo todo;
  final _formkey = GlobalKey<FormState>();
  String? userName;
  EditDialog({super.key, required this.todo, required this.userName});

  @override
  Widget build(BuildContext context) {
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Todo Details'),
          CloseButton(
            color: BrandColor.primary,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Title",
                      style: TextStyle(
                          color: BrandColor.background.shade400,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    key: const Key("EditTitleButton"),
                    onPressed: () {
                      TextEditingController editTitle = TextEditingController();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                content: Form(
                                  key: _formkey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Enter new title.',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please put a title.";
                                          }

                                          return null;
                                        },
                                        controller: editTitle,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        side: BorderSide(
                                            width: 2,
                                            color: BrandColor.primary),
                                      ),
                                      child: Text('Cancel',
                                          style: TextStyle(
                                              color: BrandColor.primary))),
                                  ElevatedButton(
                                    key: const Key("submitEditTitleButton"),
                                    onPressed: () async {
                                      // Submit the form and close the dialog
                                      if (_formkey.currentState!.validate()) {
                                        await context
                                            .read<TodoListProvider>()
                                            .editTitle(todo.id ?? "",
                                                editTitle.text, userName ?? "");

                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);

                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      }
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                BrandColor.primary),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ))),
                                    child: const Text('Submit'),
                                  ),
                                ],
                              ));
                    },
                    icon: const Icon(Icons.edit),
                    color: BrandColor.background.shade600,
                    iconSize: 18,
                  )
                ],
              ),
              Text(todo.title,
                  style: TextStyle(
                    color: BrandColor.background.shade400,
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Description",
                      style: TextStyle(
                          color: BrandColor.background.shade400,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    key: const Key("descriptionEditButton"),
                    onPressed: () {
                      TextEditingController descriptionController =
                          TextEditingController();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                content: Form(
                                  key: _formkey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Enter new description.',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please put a description.";
                                          }

                                          return null;
                                        },
                                        controller: descriptionController,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        side: BorderSide(
                                            width: 2,
                                            color: BrandColor.primary),
                                      ),
                                      child: Text('Cancel',
                                          style: TextStyle(
                                              color: BrandColor.primary))),
                                  ElevatedButton(
                                    key: const Key("SubmitDescriptionButton"),
                                    onPressed: () async {
                                      // Submit the form and close the dialog
                                      if (_formkey.currentState!.validate()) {
                                        await context
                                            .read<TodoListProvider>()
                                            .editDescription(
                                                todo.id ?? "",
                                                descriptionController.text,
                                                userName ?? "");

                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);

                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      }
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                BrandColor.primary),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ))),
                                    child: const Text('Submit'),
                                  ),
                                ],
                              ));
                    },
                    icon: const Icon(Icons.edit),
                    color: BrandColor.background.shade600,
                    iconSize: 18,
                  )
                ],
              ),
              Text(todo.description,
                  style: TextStyle(
                    color: BrandColor.background.shade400,
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Deadline",
                      style: TextStyle(
                          color: BrandColor.background.shade400,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    key: const Key("deadlineEditButton"),
                    onPressed: () {
                      TextEditingController deadlineController =
                          TextEditingController();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                content: Form(
                                  key: _formkey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextFormField(
                                        key: const Key("deadlineFormField"),
                                        decoration: const InputDecoration(
                                          labelText: 'Enter new deadline.',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please put a deadline.";
                                          }

                                          RegExp r = RegExp(
                                              r"^[1-2][0-9]{3}\-[0-1][0-9]\-[0-3][0-9]$");

                                          if (!r.hasMatch(value)) {
                                            return "Please put a valid deadline!";
                                          }

                                          return null;
                                        },
                                        controller: deadlineController,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        side: BorderSide(
                                            width: 2,
                                            color: BrandColor.primary),
                                      ),
                                      child: Text('Cancel',
                                          style: TextStyle(
                                              color: BrandColor.primary))),
                                  ElevatedButton(
                                    key: const Key("SubmitDeadlineButton"),
                                    onPressed: () async {
                                      // Submit the form and close the dialog
                                      if (_formkey.currentState!.validate()) {
                                        await context
                                            .read<TodoListProvider>()
                                            .editDeadline(
                                                todo.id ?? "",
                                                deadlineController.text,
                                                userName ?? "");

                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);

                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      }
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                BrandColor.primary),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ))),
                                    child: const Text('Submit'),
                                  ),
                                ],
                              ));
                    },
                    icon: const Icon(Icons.edit),
                    color: BrandColor.background.shade600,
                    iconSize: 18,
                  )
                ],
              ),
              Text(
                  "${months[todo.deadline.month - 1]} ${todo.deadline.day}, ${todo.deadline.year}",
                  style: TextStyle(
                    color: BrandColor.background.shade400,
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Date Created",
                  style: TextStyle(
                      color: BrandColor.background.shade400,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              Text(
                  "${months[todo.dateCreated.month - 1]} ${todo.dateCreated.day}, ${todo.dateCreated.year}",
                  style: TextStyle(
                    color: BrandColor.background.shade400,
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Last Edit By",
                  style: TextStyle(
                      color: BrandColor.background.shade400,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              Text(
                  todo.lastEditBy != null
                      ? todo.lastEditBy!
                      : "Not yet edited by anyone.",
                  style: TextStyle(
                    color: BrandColor.background.shade400,
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Last Date Edited",
                  style: TextStyle(
                      color: BrandColor.background.shade400,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              Text(
                  todo.lastEditDate != null
                      ? todo.lastEditDate.toString()
                      : "Not yet edited by anyone.",
                  style: TextStyle(
                    color: BrandColor.background.shade400,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
