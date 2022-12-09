// lib import
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:week7_networking_discussion/models/index.dart';

// api import
import 'package:week7_networking_discussion/api/index.dart';

class UserProvider with ChangeNotifier {
  FirebaseUserAPI firebaseService = FirebaseUserAPI();
  late Stream<QuerySnapshot> _friendsStream;
  late Stream<QuerySnapshot> _searchFriendStream;
  late Stream<QuerySnapshot> _user;
  late Stream<QuerySnapshot> _friendRequestStream;
  late Stream<QuerySnapshot> _sentFriendRequestStream;
  late Person currentUser;
  late Person? _searchedUser;
  late bool searching;

  UserProvider() {
    searching = false;
  }

  // getter function
  Stream<QuerySnapshot> get user => _user;
  Stream<QuerySnapshot> get searchStream => _searchFriendStream;
  Stream<QuerySnapshot> get friends => _friendsStream;
  Stream<QuerySnapshot> get friendRequests => _friendRequestStream;
  Stream<QuerySnapshot> get pendingFriendRequests => _sentFriendRequestStream;

  Person? get visitedUser => _searchedUser;

  searchPossibleUsers(String displayName) {
    searching = true;
    notifyListeners();
  }

  void fetchFriends({required String userID}) {
    _friendsStream = firebaseService.getFriends(userID);

    notifyListeners();
  }

  void fetchFriendRequests({required String userID}) {
    _friendRequestStream = firebaseService.getFriendRequests(userID);

    notifyListeners();
  }

  void fetchSentFriendRequests({required String userID}) {
    _sentFriendRequestStream = firebaseService.getSentFriendRequests(userID);

    notifyListeners();
  }

  void getPeopleUserMightKnow({required String userID}) {
    _searchFriendStream = firebaseService.getPeopleUserMightKnow(userID);

    notifyListeners();
  }

  removeFriend(
      {required String firstUserID, required String secondUserID}) async {
    await firebaseService.removeFriend(firstUserID, secondUserID);
    notifyListeners();
  }

  cancelSentFriendRequest(
      {required String senderFriendRequestID,
      required String receiverFriendRequestID}) async {
    await firebaseService.cancelSentFriendRequest(
        senderFriendRequestID: senderFriendRequestID,
        receiverFriendRequestID: receiverFriendRequestID);
    notifyListeners();
  }

  acceptFriendRequest(
      {required String loggedUserID, required String requesterUserID}) async {
    await firebaseService.acceptFriendRequest(
        senderFriendRequestID: requesterUserID,
        receiverFriendRequestID: loggedUserID);
    notifyListeners();
  }

  rejectFriendRequest(
      {required String loggedUserID, required String requesterUserID}) async {
    await firebaseService.rejectFriendRequest(loggedUserID, requesterUserID);
    notifyListeners();
  }

  sendFriendRequest(
      {required String senderFriendRequestID,
      required String receiverFriendRequestID}) async {
    await firebaseService.sendFriendRequest(
        senderFriendRequestID: senderFriendRequestID,
        receiverFriendRequestID: receiverFriendRequestID);
    notifyListeners();
  }
}
