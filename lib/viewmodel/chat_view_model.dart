import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/constants.dart';

import '../model/Message.dart';

class ChatViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createChat(String userId1, String userId2) async {
    try {
      DocumentReference chatRef = await _firestore.runTransaction((transaction) async {
        var data = {kUsersCollection: [userId1, userId2]};
        return _firestore.collection(kChatCollection).add(data);
      });

      return chatRef.id;
    } catch (error) {
      print('Erreur lors de la création du chat : $error');
      rethrow;
    }
  }

  Future<String> getChat(String userId1, String userId2) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(kChatCollection)
          .where(kUsersCollection, whereIn: [
            [userId1, userId2],
            [userId2, userId1]
          ])
          .get();

      if (querySnapshot.docs.isNotEmpty) {

        return querySnapshot.docs.first.id;
      } else {
        return await createChat(userId1, userId2);
      }
    } catch (error) {
      print('Erreur lors de la récupération du chat : $error');
      rethrow;
    }
  }

  Future<void> sendNewMessage({
    required String chatId,
    required String from,
    required String to,
    required String content,
    required String timestamp,
  }) async {
    try {
      await _firestore.runTransaction((transaction) async {
        await transaction.set(
          _firestore.collection(kChatCollection).doc(chatId).collection(kMessagesCollection).doc(),
          {
            'from': from,
            'to': to,
            'content': content,
            'timestamp': timestamp,
          },
        );
      });
    } catch (error) {
      print('Erreur lors de l\'envoi du message : $error');
      rethrow;
    }
  }

  Future<void> removeChat(String chatId) async {
    try {
      await _firestore.runTransaction((transaction) async {
        await transaction.delete(_firestore.collection(kChatCollection).doc(chatId));
      });
    } catch (e) {
      print('Erreur lors de la suppression du chat: $e');
    }
  }

  Stream<List<Message>> getTwoUserChatMessages(String chatId) {
    try {
      return _firestore
          .collection(kChatCollection)
          .doc(chatId)
          .collection(kMessagesCollection)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) => Message.fromDocument(doc)).toList();
      });
    } catch (error) {
      print('Erreur : $error');
      rethrow;
    }
  }

}
