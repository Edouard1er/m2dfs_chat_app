import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/chat_user.dart';

class ChatUserViewModel extends ChangeNotifier {
  List<ChatUser> _userList = [];

  final userCollectionName = 'users';

  List<ChatUser> get userList => _userList;

  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;

  ChatUserViewModel({
    required this.prefs,
    required this.firebaseFirestore
  });

  String? getPrefs(String key) {
    return prefs.getString(key);
  }

  Future<bool> setPrefs(String key, String value) async {
    return await prefs.setString(key, value);
  }

  void setUserList(List<ChatUser> userList) {
    _userList = userList;
    notifyListeners();
  }

  Future<void> createUserInFirestore(ChatUser user) async {
    try {
      Map<String, dynamic> userData = {
        'id': user.id,
        'bio': user.bio,
        'displayName': user.displayName,
        'avatarUrl': user.avatarUrl,
      };

      await FirebaseFirestore.instance.collection(userCollectionName).doc(user.id).set(userData);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ChatUser?> getDataForCurrentUser() async {
    try {
      final id = FirebaseAuth.instance.currentUser?.uid;

      if(id == null) {
        return ChatUser.empty();
      }
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(userCollectionName).doc(id).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return ChatUser(
            id: id ,
            displayName: userData['displayName'] ?? '',
            bio: userData['bio'] ?? '',
            avatarUrl: userData['avatarUrl'] ?? ''
        );

      } else {
        ChatUser user = ChatUser(
          id: id ?? '',
          displayName: FirebaseAuth.instance.currentUser?.displayName ?? 'Change ton nom',
          bio: '',
          avatarUrl: FirebaseAuth.instance.currentUser?.photoURL ?? '',
        );
        await createUserInFirestore(user);
        return user;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateCurrentUser(String id, Map<String, dynamic> data) {
    return firebaseFirestore.collection(userCollectionName).doc(id).update(data);
  }

  Stream<QuerySnapshot> getUserList() {
    return firebaseFirestore
        .collection(userCollectionName)
        .snapshots();
  }
}
