import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m2dfs_chat_app/model/chat_user.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final SharedPreferences _prefs;

  AuthStatus _status = AuthStatus.uninitialized;

  AuthStatus get status => _status;

  AuthViewModel({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
    required SharedPreferences prefs,
  })   : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        _prefs = prefs;

  String? getCurrentUserId() {
    return _prefs.getString("id");
  }

  String? getCurrentUserDisplayName() {
    return _prefs.getString("displayName");
  }

  String? getCurrentUserAvatarUrl() {
    return _prefs.getString("avatarUrl");
  }

  String? getPrefs(String key) {
    return _prefs.getString(key);
  }

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = _firebaseAuth.currentUser != null;
    if (isLoggedIn && _prefs.getString("id")?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    
    _status = AuthStatus.authenticating;
    notifyListeners();
    await _prefs.setString("signInErrorMessage", "");

    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final authUser = credential.user;

      if (authUser != null) {
        final QuerySnapshot result = await _firebaseFirestore.collection("users").where("id", isEqualTo: authUser.uid).get();

        final List<DocumentSnapshot> document = result.docs;
        if (document.isEmpty) {
          _firebaseFirestore.collection("users").doc(authUser.uid).set({
              "displayName": authUser.displayName,
              "avatarUrl": authUser.photoURL,
              "bio": "",
              "id": authUser.uid,
          });

          final currentUser = authUser;
          await _prefs.setString("id", currentUser.uid);
          await _prefs.setString("displayName", currentUser.displayName ?? "",);
          await _prefs.setString("avatarUrl",currentUser.photoURL ?? "",);
          await _prefs.setString("bio", "",);
          
        } else {
          DocumentSnapshot documentSnapshot = document[0];
          ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
          await _prefs.setString("id", userChat.id);
          await _prefs.setString(
            "displayName",
            userChat.displayName,
          );
          await _prefs.setString("bio", userChat?.bio ?? "");
          await _prefs.setString("avatarUrl", userChat?.avatarUrl ?? "");
        }

        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.authenticationError;
        notifyListeners();
        return false;
      }
    } on FirebaseAuthException catch (e, stackTrace) {
      final String errorMessage;

      if (e.code == 'user-not-found') {
        errorMessage = 'Aucun utilisateur trouvé pour cet email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Mot de passe incorrect.';
      } else {
        errorMessage = 'Une erreur s\'est produite';
      }

      await _prefs.setString("signInErrorMessage", errorMessage ?? "");

      log(
        'Error while signing in: ${e.code}',
        error: e,
        stackTrace: stackTrace,
        name: 'SignInPage',
      );

      _status = AuthStatus.authenticationError;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {

    await _prefs.setString("signUpErrorMessage", "");

    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final authUser = credential.user;

      if (authUser != null) {
        final QuerySnapshot result = await _firebaseFirestore.collection("users").where("id", isEqualTo: authUser.uid).get();

        final List<DocumentSnapshot> document = result.docs;
        if (document.isEmpty) {
          _firebaseFirestore.collection("users").doc(authUser.uid).set({
            "displayName": authUser.displayName ?? name,
            "avatarUrl": authUser.photoURL,
            "bio": "",
            "id": authUser.uid,
          });

          final currentUser = authUser;
          await _prefs.setString("id", currentUser.uid);
          await _prefs.setString("displayName", currentUser.displayName ?? name,);
          await _prefs.setString("avatarUrl",currentUser.photoURL ?? "",);
          await _prefs.setString("bio", "",);

        } else {
          DocumentSnapshot documentSnapshot = document[0];
          ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
          await _prefs.setString("id", userChat.id);
          await _prefs.setString(
            "displayName",
            userChat.displayName,
          );
          await _prefs.setString("bio", userChat?.bio ?? "");
          await _prefs.setString("avatarUrl", userChat?.avatarUrl ?? "");
        }

        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.authenticationError;
        notifyListeners();
        return false;
      }
    } on FirebaseAuthException catch (e, stackTrace) {
      final String errorMessage;

      if (e.code == 'user-not-found') {
        errorMessage = 'Aucun utilisateur trouvé pour cet email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Mot de passe incorrect.';
      } else {
        errorMessage = 'Une erreur s\'est produite';
      }

      await _prefs.setString("signUpErrorMessage", errorMessage ?? "");

      log(
        'Error while signing in: ${e.code}',
        error: e,
        stackTrace: stackTrace,
        name: 'SignInPage',
      );
      print(errorMessage);
      _status = AuthStatus.authenticationError;
      notifyListeners();
      return false;
    }
  }


  Future<void> signOut() async {
    _status = AuthStatus.uninitialized;
    await _firebaseAuth.signOut();
  }
}

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  authenticationError,
  authenticationCanceled,
}