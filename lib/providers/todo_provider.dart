/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking
*/

import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/api/firebase_todo_api.dart';
import 'package:week7_networking_discussion/models/todo/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoListProvider with ChangeNotifier {
  late FirebaseTodoAPI firebaseService;
  late Stream<QuerySnapshot> _todosStream;
  late Stream<QuerySnapshot> _friendTodosStream;
  // Todo? _selectedTodo;

  TodoListProvider() {
    firebaseService = FirebaseTodoAPI();
  }

  // getter
  Stream<QuerySnapshot> get todos => _todosStream;
  Stream<QuerySnapshot> get friendTodos => _friendTodosStream;

  void fetchTodos(String id) {
    _todosStream = firebaseService.getAllTodos(id);
    notifyListeners();
  }

  void fetchFriendTodos(List<dynamic> friends) {
    _friendTodosStream = firebaseService.getFriendsTodos(friends);
    notifyListeners();
  }

  void addTodo(Todo item) async {
    await firebaseService.addTodo(Todo.toJson(item));
    notifyListeners();
  }

  void editTodo(String id, String newTitle) async {
    // _todoList[index].title = newTitle;
    await firebaseService.editTodo(id, newTitle);
    notifyListeners();
  }

  Future editTitle(String id, String newTitle, String name) async {
    // _todoList[index].title = newTitle;
    await firebaseService.editTitle(id, newTitle, name);
    notifyListeners();
  }

  Future editDescription(String id, String newDescription, String name) async {
    // _todoList[index].title = newTitle;
    await firebaseService.editDescription(id, newDescription, name);
    notifyListeners();
  }

  Future editDeadline(String id, String newDeadline, String name) async {
    // _todoList[index].title = newTitle;
    await firebaseService.editDeadline(id, newDeadline, name);
    notifyListeners();
  }

  void deleteTodo(String id) async {
    await firebaseService.deleteTodo(id);

    notifyListeners();
  }

  Future toggleStatus(String id, bool status, String userId) async {
    await firebaseService.toggleTodoStatus(id, status, userId);
    notifyListeners();
  }
}
