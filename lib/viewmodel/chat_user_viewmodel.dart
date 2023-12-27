import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/chat_user.dart';

class ChatUserViewModel extends ChangeNotifier {
  List<ChatUser> _userList = [];

  List<ChatUser> get userList => _userList;

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

      await FirebaseFirestore.instance.collection('users').doc(user.id).set(userData);
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
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(id).get();
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
          displayName: FirebaseAuth.instance.currentUser?.displayName ?? '',
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

  Future<void> fetchUserList() async {
    List<ChatUser> userList = [];

    try {
      final resp = await FirebaseFirestore.instance.collection("users").get();
      for (var user in resp.docs) {
        Map<String, dynamic>? data = user.data();

        if (data == null || !data.containsKey('displayName')) {
          continue;
        }

        String userId = data["id"];

        String displayName = data['displayName'] ?? 'Default Display Name';
        String? bio = data['bio'];
        String? avatarUrl = data['avatarUrl'];

        ChatUser chatUser = ChatUser(
          id: userId,
          displayName: displayName,
          bio: bio,
          avatarUrl: avatarUrl,
        );

        userList.add(chatUser);
      }

      setUserList(userList);
    }catch ( e) {
      print("Error getting data: $e");
      return ;
    }
  }
}
