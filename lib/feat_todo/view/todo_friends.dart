/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo/index.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Component
import './modal_todo.dart';

// Brand
import 'package:week7_networking_discussion/config/theme/index.dart';

class TodoFriendsPage extends StatefulWidget {
  const TodoFriendsPage({super.key});

  @override
  State<TodoFriendsPage> createState() => _TodoFriendsPageState();
}

class _TodoFriendsPageState extends State<TodoFriendsPage> {
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;
    String? userId = context.watch<AuthProvider>().userId;
    String? userName = context.watch<AuthProvider>().userName;

    final _formkey = GlobalKey<FormState>();

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

    return Scaffold(
      backgroundColor: BrandColor.primary.shade50,
      appBar: AppBar(
        title: Text("Friends' Todo",
            style: TextStyle(
                color: BrandColor.primary.shade50,
                fontWeight: FontWeight.w700)),
        backgroundColor: BrandColor.primary,
        leading: BackButton(color: BrandColor.primary.shade50),
      ),
      body: StreamBuilder(
        stream: todosStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No Todos Found"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              Todo todo = Todo.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);

              return Dismissible(
                key: Key(todo.id.toString()),
                onDismissed: (direction) {
                  // context.read<TodoListProvider>().changeSelectedTodo(todo);
                  context.read<TodoListProvider>().deleteTodo(todo.id ?? "");

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${todo.title} dismissed')));
                },
                background: Container(
                  color: BrandColor.error,
                  child: Icon(
                    Icons.delete,
                    color: BrandColor.primary.shade50,
                  ),
                ),
                child: ListTile(
                  title: InkWell(
                    child: Text(
                      todo.title,
                      style: TextStyle(
                          color: BrandColor.background.shade700, fontSize: 15),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("Title",
                                                style: TextStyle(
                                                    color: BrandColor
                                                        .background.shade400,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                TextEditingController
                                                    editTitle =
                                                    TextEditingController();
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                              content: Form(
                                                                key: _formkey,
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    TextFormField(
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        labelText:
                                                                            'Enter new title.',
                                                                      ),
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return "Please put a title.";
                                                                        }

                                                                        return null;
                                                                      },
                                                                      controller:
                                                                          editTitle,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                OutlinedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    style: OutlinedButton
                                                                        .styleFrom(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(18.0),
                                                                      ),
                                                                      side: BorderSide(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              BrandColor.primary),
                                                                    ),
                                                                    child: Text(
                                                                        'Cancel',
                                                                        style: TextStyle(
                                                                            color:
                                                                                BrandColor.primary))),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    // Submit the form and close the dialog
                                                                    if (_formkey
                                                                        .currentState!
                                                                        .validate()) {
                                                                      await context.read<TodoListProvider>().editTitle(
                                                                          todo.id ??
                                                                              "",
                                                                          editTitle
                                                                              .text,
                                                                          userName ??
                                                                              "");

                                                                      // ignore: use_build_context_synchronously
                                                                      Navigator.pop(
                                                                          context);

                                                                      // ignore: use_build_context_synchronously
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                  style: ButtonStyle(
                                                                      backgroundColor: MaterialStateProperty.all(BrandColor.primary),
                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(18.0),
                                                                      ))),
                                                                  child: const Text(
                                                                      'Submit'),
                                                                ),
                                                              ],
                                                            ));
                                              },
                                              icon: const Icon(Icons.edit),
                                              color: BrandColor
                                                  .background.shade600,
                                              iconSize: 18,
                                            )
                                          ],
                                        ),
                                        Text(todo.title,
                                            style: TextStyle(
                                              color: BrandColor
                                                  .background.shade400,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("Description",
                                                style: TextStyle(
                                                    color: BrandColor
                                                        .background.shade400,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                TextEditingController
                                                    descriptionController =
                                                    TextEditingController();
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                              content: Form(
                                                                key: _formkey,
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    TextFormField(
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        labelText:
                                                                            'Enter new description.',
                                                                      ),
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return "Please put a description.";
                                                                        }

                                                                        return null;
                                                                      },
                                                                      controller:
                                                                          descriptionController,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                OutlinedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    style: OutlinedButton
                                                                        .styleFrom(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(18.0),
                                                                      ),
                                                                      side: BorderSide(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              BrandColor.primary),
                                                                    ),
                                                                    child: Text(
                                                                        'Cancel',
                                                                        style: TextStyle(
                                                                            color:
                                                                                BrandColor.primary))),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    // Submit the form and close the dialog
                                                                    if (_formkey
                                                                        .currentState!
                                                                        .validate()) {
                                                                      await context.read<TodoListProvider>().editDescription(
                                                                          todo.id ??
                                                                              "",
                                                                          descriptionController
                                                                              .text,
                                                                          userName ??
                                                                              "");

                                                                      // ignore: use_build_context_synchronously
                                                                      Navigator.pop(
                                                                          context);

                                                                      // ignore: use_build_context_synchronously
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                  style: ButtonStyle(
                                                                      backgroundColor: MaterialStateProperty.all(BrandColor.primary),
                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(18.0),
                                                                      ))),
                                                                  child: const Text(
                                                                      'Submit'),
                                                                ),
                                                              ],
                                                            ));
                                              },
                                              icon: const Icon(Icons.edit),
                                              color: BrandColor
                                                  .background.shade600,
                                              iconSize: 18,
                                            )
                                          ],
                                        ),
                                        Text(todo.description,
                                            style: TextStyle(
                                              color: BrandColor
                                                  .background.shade400,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("Deadline",
                                                style: TextStyle(
                                                    color: BrandColor
                                                        .background.shade400,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                TextEditingController
                                                    deadlineController =
                                                    TextEditingController();
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                              content: Form(
                                                                key: _formkey,
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    TextFormField(
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        labelText:
                                                                            'Enter new deadline.',
                                                                      ),
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return "Please put a deadline.";
                                                                        }

                                                                        RegExp
                                                                            r =
                                                                            RegExp(r"^[1-2][0-9]{3}\-[0-1][0-9]\-[0-3][0-9]$");

                                                                        if (!r.hasMatch(
                                                                            value)) {
                                                                          return "Please put a valid deadline!";
                                                                        }

                                                                        return null;
                                                                      },
                                                                      controller:
                                                                          deadlineController,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                OutlinedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    style: OutlinedButton
                                                                        .styleFrom(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(18.0),
                                                                      ),
                                                                      side: BorderSide(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              BrandColor.primary),
                                                                    ),
                                                                    child: Text(
                                                                        'Cancel',
                                                                        style: TextStyle(
                                                                            color:
                                                                                BrandColor.primary))),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    // Submit the form and close the dialog
                                                                    if (_formkey
                                                                        .currentState!
                                                                        .validate()) {
                                                                      await context.read<TodoListProvider>().editDeadline(
                                                                          todo.id ??
                                                                              "",
                                                                          deadlineController
                                                                              .text,
                                                                          userName ??
                                                                              "");

                                                                      // ignore: use_build_context_synchronously
                                                                      Navigator.pop(
                                                                          context);

                                                                      // ignore: use_build_context_synchronously
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                  style: ButtonStyle(
                                                                      backgroundColor: MaterialStateProperty.all(BrandColor.primary),
                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(18.0),
                                                                      ))),
                                                                  child: const Text(
                                                                      'Submit'),
                                                                ),
                                                              ],
                                                            ));
                                              },
                                              icon: const Icon(Icons.edit),
                                              color: BrandColor
                                                  .background.shade600,
                                              iconSize: 18,
                                            )
                                          ],
                                        ),
                                        Text(
                                            "${months[todo.deadline.month - 1]} ${todo.deadline.day}, ${todo.deadline.year}",
                                            style: TextStyle(
                                              color: BrandColor
                                                  .background.shade400,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Date Created",
                                            style: TextStyle(
                                                color: BrandColor
                                                    .background.shade400,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Text(
                                            "${months[todo.dateCreated.month - 1]} ${todo.dateCreated.day}, ${todo.dateCreated.year}",
                                            style: TextStyle(
                                              color: BrandColor
                                                  .background.shade400,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Last Edit By",
                                            style: TextStyle(
                                                color: BrandColor
                                                    .background.shade400,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Text(
                                            todo.lastEditBy != null
                                                ? todo.lastEditBy!
                                                : "Not yet edited by anyone.",
                                            style: TextStyle(
                                              color: BrandColor
                                                  .background.shade400,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Last Date Edited",
                                            style: TextStyle(
                                                color: BrandColor
                                                    .background.shade400,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Text(
                                            todo.lastEditDate != null
                                                ? todo.lastEditDate.toString()
                                                : "Not yet edited by anyone.",
                                            style: TextStyle(
                                              color: BrandColor
                                                  .background.shade400,
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ));
                    },
                  ),
                  leading: Theme(
                      data: ThemeData(
                          unselectedWidgetColor: BrandColor.primary.shade500),
                      child: Checkbox(
                        value: todo.completed,
                        onChanged: (bool? value) async {
                          await context.read<TodoListProvider>().toggleStatus(
                              todo.id ?? "", value!, userName ?? "");
                        },
                        activeColor: BrandColor.primary,
                        checkColor: BrandColor.primary.shade50,
                      )),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => TodoModal(
                                type: 'Delete',
                                createdBy: userId ?? "",
                                id: todo.id,
                                title: todo.title),
                          );
                        },
                        icon: Icon(
                          Icons.delete_outlined,
                          color: BrandColor.error,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: BrandColor.primary,
        foregroundColor: BrandColor.primary.shade50,
        onPressed: () {
          TextEditingController titleController = TextEditingController();
          TextEditingController descriptionController = TextEditingController();
          TextEditingController deadlineController = TextEditingController();
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text('Create a new Todo'),
                    content: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Enter title.',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please put a title.";
                              }

                              return null;
                            },
                            controller: titleController,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Enter description.',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please put a description.";
                              }

                              return null;
                            },
                            controller: descriptionController,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Enter deadline date.',
                                helperText: "Format: YYYY-MM-DD"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please put a deadline date.";
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
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          side: BorderSide(width: 2, color: BrandColor.primary),
                        ),
                        child: Text('Cancel',
                            style: TextStyle(color: BrandColor.primary)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            // Submit the form and close the dialog
                            if (_formkey.currentState!.validate()) {
                              context.read<TodoListProvider>().addTodo(Todo(
                                  createdBy: userId!,
                                  deadline:
                                      DateTime.parse(deadlineController.text),
                                  dateCreated: DateTime.now(),
                                  completed: false,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  author: userName!));

                              Navigator.pop(context);
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(BrandColor.primary),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                          child: const Text('Submit')),
                    ],
                  ));
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
