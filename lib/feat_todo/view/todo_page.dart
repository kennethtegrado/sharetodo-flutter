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

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;
    String? userId = context.watch<AuthProvider>().userId;

    return Scaffold(
      backgroundColor: BrandColor.primary.shade50,
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        ListTile(
          title: const Text('Logout'),
          onTap: () {
            context.read<AuthProvider>().signOut();
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Profile'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        )
      ])),
      appBar: AppBar(
        title: Text(
          "Todo",
          style: TextStyle(
              color: BrandColor.primary.shade50, fontWeight: FontWeight.w700),
        ),
        leading: Builder(
            builder: (context) => IconButton(
                  icon: const Icon(Icons.sort),
                  color: BrandColor.primary.shade50,
                  onPressed: () => Scaffold.of(context).openDrawer(),
                )),
        backgroundColor: BrandColor.primary,
        shadowColor: BrandColor.primary.shade600,
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
                  color: Colors.red,
                  child: const Icon(Icons.delete),
                ),
                child: ListTile(
                  title: Text(todo.title),
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (bool? value) async {
                      await context
                          .read<TodoListProvider>()
                          .toggleStatus(todo.id ?? "", value!);
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => TodoModal(
                              type: 'Edit',
                              createdBy: userId ?? "",
                              id: todo.id,
                            ),
                          );
                        },
                        icon: const Icon(Icons.create_outlined),
                      ),
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
                        icon: const Icon(Icons.delete_outlined),
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
          showDialog(
            context: context,
            builder: (BuildContext context) => TodoModal(
              type: 'Add',
              createdBy: userId ?? "",
            ),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
