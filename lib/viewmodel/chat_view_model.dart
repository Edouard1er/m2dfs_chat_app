import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/chat.dart';

class ChatViewModel extends ChangeNotifier {
  List<Chat> _chatList = [];

  List<Chat> get chatList => _chatList;

  void setChatList(List<Chat> chats) {
    _chatList = chats;
    notifyListeners();
  }

  Future<void> fetchChats() async {
    List<Chat> chatList = [];

    try {
      final snapshot = await FirebaseFirestore.instance.collection("chats").get();
      for (var chatDoc in snapshot.docs) {

        Map<String, dynamic>? data = chatDoc.data();


        if (data == null || !data.containsKey('users')) {
          continue;
        }

        String chatId = chatDoc.id;

        List<String> users = List<String>.from(data['users'] ?? []);

        Chat chat = Chat(
          id: chatId,
          users: users,
        );

        chatList.add(chat);
      }

      setChatList(chatList);
      print('Chat list length: ${chatList.length}');
    } catch (e) {
      print("Error getting chats: $e");
      return;
    }
  }

  Future<void> addChat(List<String> users) async {
    try {
      final chatData = {'users': users};
      final docRef = await FirebaseFirestore.instance.collection('chats').add(chatData);
      print('Added chat with ID: ${docRef.id}');
      fetchChats();
    } catch (e) {
      print('Error adding chat: $e');
    }
  }



  Future<void> removeChat(String chatId) async {
    try {
      await FirebaseFirestore.instance.collection('chats').doc(chatId).delete();
      fetchChats();
    } catch (e) {
      print('Error removing chat: $e');
    }
  }
}
