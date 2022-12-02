import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:week7_networking_discussion/utils/exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

// Model
import 'package:week7_networking_discussion/utils/response.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  // final db = FakeFirebaseFirestore();

  // final auth = MockFirebaseAuth(
  //     mockUser: MockUser(
  //   isAnonymous: false,
  //   uid: 'someuid',
  //   email: 'charlie@paddyspub.com',
  //   displayName: 'Charlie',
  // ));

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  Future<Response> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ErrorResponse('No user found.', ErrorType.userNotFound);
      } else if (e.code == 'wrong-password') {
        return ErrorResponse(
            'Incorrect password.', ErrorType.incorrectPassword);
      } else if (e.code == 'invalid-email') {
        return ErrorResponse(
            '$email is an invalid email.', ErrorType.invalidEmail);
      }
      return ErrorResponse('Unknown error!', ErrorType.unknownError);
    } catch (e) {
      return ErrorResponse('Unknown error!', ErrorType.unknownError);
    }

    return SuccessResponse("User successfully logged in!");
  }

  void signOut() async {
    auth.signOut();
  }

  Future<Response> signUp(
      {required String email,
      required String password,
      required String firstName,
      required String lastName}) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await saveUserToFirestore(
            credential.user?.uid, email, firstName, lastName);
      }
      return SuccessResponse("User successfully created!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ErrorResponse(
            'The password provided is too weak.', ErrorType.weakPassword);
      } else if (e.code == 'email-already-in-use') {
        return ErrorResponse(
            'The email is already used.', ErrorType.emailAlreadyExists);
      }
    } on InvalidEmailException catch (e) {
      return ErrorResponse(e.message, ErrorType.invalidEmail);
    } catch (error) {
      return ErrorResponse("Something went wrong", ErrorType.unknownError);
    }
    return ErrorResponse("Something went wrong!", ErrorType.unknownError);
  }

  Future saveUserToFirestore(
      String? uid, String email, String firstName, String lastName) async {
    await db.collection("users").doc(uid).set({
      "email": email,
      "id": uid.toString(),
      "firstName": firstName,
      "lastName": lastName,
      "fullName": "$firstName $lastName",
      "bio": null,
      "age": null,
      "birthDay": null,
      "friends": [],
      "friendRequests": [],
      "sentFriendRequests": [],
      "userName": null
    });
  }
}
