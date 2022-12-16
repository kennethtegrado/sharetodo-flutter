/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/feat_todo/view/edit_dialog.dart';
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
    Stream<QuerySnapshot> todosStream =
        context.watch<TodoListProvider>().friendTodos;
    String? userId = context.watch<AuthProvider>().userId;
    String? userName = context.watch<AuthProvider>().userName;

    final formkey = GlobalKey<FormState>();

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
            return Center(
              child: Text("You have lazy friends!",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: BrandColor.background.shade800)),
            );
          } else if (snapshot.data != null && snapshot.data?.docs != null) {
            List<QueryDocumentSnapshot<Object?>>? docs = snapshot.data?.docs;

            if (docs != null && docs.isEmpty) {
              return Center(
                child: Text("You have lazy friends!",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: BrandColor.background.shade800)),
              );
            }
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              Todo todo = Todo.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);

              return ListTile(
                title: InkWell(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Todo by ${todo.author}",
                          style: TextStyle(
                              fontSize: 12,
                              color: BrandColor.background.shade400),
                        ),
                        Text(
                          todo.title,
                          style: TextStyle(
                              color: BrandColor.background.shade700,
                              fontSize: 15),
                        )
                      ]),
                ),
                leading: Theme(
                    data: ThemeData(
                        unselectedWidgetColor: BrandColor.primary.shade500),
                    child: Checkbox(
                      value: todo.completed,
                      onChanged: null,
                      activeColor: BrandColor.primary,
                      checkColor: BrandColor.primary.shade50,
                    )),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              EditDialog(todo: todo, userName: userName),
                        );
                      },
                      child: Text("View More",
                          style: TextStyle(color: BrandColor.primary.shade400)),
                    )
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
