// lib import
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore database = FirebaseFirestore.instance;

  final CollectionReference<Map<String, dynamic>> userDatabase =
      database.collection("users");

  FirebaseUserAPI();

  Stream<QuerySnapshot> getFriends(String userID) =>
      userDatabase.where("friends", arrayContainsAny: [userID]).snapshots();

  Stream<QuerySnapshot> getFriendRequests(String userID) => userDatabase
      .where("sentFriendRequests", arrayContainsAny: [userID]).snapshots();

  Stream<QuerySnapshot> getSentFriendRequests(String userID) => userDatabase
      .where("friendRequests", arrayContainsAny: [userID]).snapshots();

  Stream<QuerySnapshot> getPeopleUserMightKnow(String userID) =>
      userDatabase.where("friends", whereNotIn: [
        [userID]
      ]).snapshots();

  Stream<QuerySnapshot> getUser(String id) {
    return userDatabase.where("id", isEqualTo: id).snapshots();
  }

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> user) async {
    final newUserRef = await userDatabase.add(user);
    await userDatabase.doc(newUserRef.id).update({"id": newUserRef.id});
    final result = await newUserRef.get();
    return result.data() as Map<String, dynamic>;
  }

  Future removeFriend(String id1, String id2) async {
    await userDatabase.doc(id1).update({
      "friends": FieldValue.arrayRemove([id2])
    });

    await userDatabase.doc(id2).update({
      "friends": FieldValue.arrayRemove([id1])
    });
  }

  Future acceptFriendRequest(
      {required String senderFriendRequestID,
      required String receiverFriendRequestID}) async {
    await userDatabase.doc(receiverFriendRequestID).update({
      "friendRequests": FieldValue.arrayRemove([senderFriendRequestID]),
      "friends": FieldValue.arrayUnion([senderFriendRequestID])
    });

    await userDatabase.doc(senderFriendRequestID).update({
      "sentFriendRequests": FieldValue.arrayRemove([receiverFriendRequestID]),
      "friends": FieldValue.arrayUnion([receiverFriendRequestID])
    });
  }

  Future rejectFriendRequest(String firstUser, String secondUser) async {
    await userDatabase.doc(firstUser).update({
      "friendRequests": FieldValue.arrayRemove([secondUser])
    });

    await userDatabase.doc(secondUser).update({
      "sentFriendRequests": FieldValue.arrayRemove([firstUser])
    });
  }

  Future cancelSentFriendRequest(
      {required String senderFriendRequestID,
      required String receiverFriendRequestID}) async {
    await userDatabase.doc(senderFriendRequestID).update({
      "sentFriendRequests": FieldValue.arrayRemove([receiverFriendRequestID]),
    });

    await userDatabase.doc(receiverFriendRequestID).update({
      "friendRequests": FieldValue.arrayRemove([senderFriendRequestID]),
    });
  }

  Future sendFriendRequest(
      {required String senderFriendRequestID,
      required String receiverFriendRequestID}) async {
    await userDatabase.doc(senderFriendRequestID).update({
      "sentFriendRequests": FieldValue.arrayUnion([receiverFriendRequestID]),
    });

    await userDatabase.doc(receiverFriendRequestID).update({
      "friendRequests": FieldValue.arrayUnion([senderFriendRequestID]),
    });
  }
}
