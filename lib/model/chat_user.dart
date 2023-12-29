import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  String id;
  String displayName;
  String? bio;
  String? avatarUrl;

  ChatUser({
    required this.id,
    required this.displayName,
    this.bio,
    this.avatarUrl,
  });

  ChatUser.empty() : id = '', displayName = '';

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'] ?? '',
      displayName: json['displayName'] ?? '',
      bio: json['bio'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'bio': bio,
      'avatarUrl': avatarUrl,
    };
  }

  factory ChatUser.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatUser(
      id: data['id'] ?? '',
      displayName: data['displayName'] ?? '',
      bio: data['bio'],
      avatarUrl: data['avatarUrl'],
    );
  }
}
