import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String sender;
  final String receiver;
  final String text;
  final String date;
  final String chatId;

  Message({
    required this.receiver,
    required this.sender,
    required this.text,
    required this.date,
    required this.chatId,
  });

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiver': receiver,
      'text': text,
      'date': date,
      'chatId': chatId,
    };
  }

  factory Message.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Message(
      sender: data['sender'] ?? '',
      receiver: data['receiver'] ?? '',
      text: data['text'] ?? '',
      date: data['date'] ?? '',
      chatId: data['chatId'] ?? '',
    );
  }
}
