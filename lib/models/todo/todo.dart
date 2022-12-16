/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking
*/

import 'dart:convert';

class Todo {
  String createdBy;
  String? id;
  String title;
  String description;
  bool completed;
  DateTime dateCreated;
  DateTime? lastEditDate;
  DateTime deadline;
  String? lastEditBy;
  String author;

  Todo(
      {required this.createdBy,
      this.id,
      required this.title,
      required this.completed,
      required this.dateCreated,
      this.lastEditDate,
      this.lastEditBy,
      required this.deadline,
      required this.description,
      required this.author});

  // Factory constructor to instantiate object from json format
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      createdBy: json['createdBy'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
      dateCreated: DateTime.parse(json["dateCreated"]),
      deadline: DateTime.parse(json["deadline"]),
      description: json["description"],
      lastEditDate: json['lastEditDate'] == null
          ? null
          : DateTime.parse(json["lastEditDate"]),
      lastEditBy: json['lastEditBy'],
      author: json['author'],
    );
  }

  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }

  static Map<String, dynamic> toJson(Todo todo) {
    return {
      'createdBy': todo.createdBy,
      'title': todo.title,
      'completed': todo.completed,
      'dateCreated': todo.dateCreated.toString(),
      'lastEditDate': todo.lastEditDate,
      'lastEditBy': todo.lastEditBy,
      "deadline": todo.deadline.toString(),
      "description": todo.description,
      "author": todo.author
    };
  }
}

/*
      createdBy: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
      dateCreated: DateTime.parse(json["dateCreated"]),
      lastEditDate:
          json['lastEditDate'] ?? DateTime.parse(json["lastEditDate"]),
      lastEditBy: json['lastEditBy'],
      dueDate: json['dueDate'],
*/ 