import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  // final db = FakeFirebaseFirestore();
  final todoDatabase = db.collection("todos");

  Future<String> addTodo(Map<String, dynamic> todo) async {
    try {
      final docRef = await todoDatabase.add(todo);
      await todoDatabase.doc(docRef.id).update({'id': docRef.id});

      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllTodos(String id) {
    return todoDatabase.where("createdBy", isEqualTo: id).snapshots();
  }

  Stream<QuerySnapshot> getFriendsTodos(List<dynamic> friends) {
    return todoDatabase.where("createdBy", whereIn: friends).snapshots();
  }

  Future<String> deleteTodo(String? id) async {
    try {
      await todoDatabase.doc(id).delete();

      return "Successfully deleted todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future toggleTodoStatus(String id, bool status, String userId) async {
    try {
      await todoDatabase.doc(id).update({
        "completed": status,
        "lastEditBy": userId,
        "lastEditDate": DateTime.now().toString()
      });
    } catch (e) {
      print(e);
    }
  }

  Future editTitle(String id, String title, String userId) async {
    try {
      await todoDatabase.doc(id).update({
        "title": title,
        "lastEditBy": userId,
        "lastEditDate": DateTime.now().toString()
      });
    } catch (e) {
      print(e);
    }
  }

  Future editDescription(String id, String description, String userId) async {
    try {
      await todoDatabase.doc(id).update({
        "description": description,
        "lastEditBy": userId,
        "lastEditDate": DateTime.now().toString()
      });
    } catch (e) {
      print(e);
    }
  }

  Future editDeadline(String id, String deadline, String userId) async {
    try {
      await todoDatabase.doc(id).update({
        "deadline": deadline,
        "lastEditBy": userId,
        "lastEditDate": DateTime.now().toString()
      });
    } catch (e) {
      print(e);
    }
  }

  Future editTodo(String id, String title) async {
    try {
      await todoDatabase.doc(id).update({"title": title});
    } catch (e) {
      print(e);
    }
  }
}
