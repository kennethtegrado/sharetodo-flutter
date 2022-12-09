/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking
*/

import 'dart:convert';

class Todo {
  String createdBy;
  String id;
  String title;
  String description;
  bool completed;
  DateTime dateCreated;
  DateTime? lastEditDate;
  DateTime? dueDate;
  String? lastEditBy;

  Todo(
      {required this.createdBy,
      required this.id,
      required this.title,
      required this.completed,
      required this.dateCreated,
      required this.lastEditDate,
      required this.lastEditBy,
      required this.dueDate,
      required this.description});

  // Factory constructor to instantiate object from json format
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        createdBy: json['userId'],
        id: json['id'],
        title: json['title'],
        completed: json['completed'],
        dateCreated: DateTime.parse(json["dateCreated"]),
        lastEditDate:
            json['lastEditDate'] ?? DateTime.parse(json["lastEditDate"]),
        lastEditBy: json['lastEditBy'],
        dueDate: json['dueDate'],
        description: json['description']);
  }

  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }

  static Map<String, dynamic> toJson(Todo todo) {
    return {
      'userId': todo.createdBy,
      'title': todo.title,
      'completed': todo.completed,
    };
  }
}
