import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/constants.dart';

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
    required String senderId,
    required String receiverId,
    required String text,
    required String date,
  }) async {
    try {
      await _firestore.runTransaction((transaction) async {
        await transaction.set(
          _firestore.collection(kChatCollection).doc(chatId).collection(kMessagesCollection).doc(),
          {
            'sender': senderId,
            'receiver': receiverId,
            'text': text,
            'date': date,
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
}
