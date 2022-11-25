import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week7_networking_discussion/api/firebase_auth_api.dart';
import 'package:week7_networking_discussion/utils/response.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  User? userObj;
  Response? _response;

  AuthProvider() {
    authService = FirebaseAuthAPI();
    authService.getUser().listen((User? newUser) {
      userObj = newUser;
      notifyListeners();
    }, onError: (e) {
      // print a more useful error
      // print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  User? get user => userObj;
  Response? get response => _response;

  bool get isAuthenticated {
    return user != null;
  }

  Future<Response> signIn(String email, String password) async {
    Response response = await authService.signIn(email, password);

    _response = response;

    notifyListeners();

    return response;
  }

  void signOut() {
    authService.signOut();
  }

  void resetResponse() {
    _response = null;

    notifyListeners();
  }

  Future<Response> signUp(
      {required String email,
      required String password,
      required String firstName,
      required String lastName}) async {
    Response response = await authService.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName);
    _response = response;
    notifyListeners();
    return response;
  }
}
