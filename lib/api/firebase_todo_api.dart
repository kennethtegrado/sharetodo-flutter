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

  Stream<QuerySnapshot> getAllTodos() {
    return todoDatabase.snapshots();
  }

  Future<String> deleteTodo(String? id) async {
    try {
      await todoDatabase.doc(id).delete();

      return "Successfully deleted todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future toggleTodoStatus(String id, bool status) async {
    try {
      await todoDatabase.doc(id).update({"completed": status});
    } catch (e) {
      print(e);
    }
  }
}
