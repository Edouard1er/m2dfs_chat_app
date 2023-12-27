import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      displayName: json['displayname'] ?? '',
      bio: json['bio'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayname': displayName,
      'bio': bio,
      'avatarUrl': avatarUrl,
    };
  }

  factory ChatUser.fromDocument(Map<String, dynamic> document) {
    return ChatUser(
      id: document['id'] ?? '',
      displayName: document['displayname'] ?? '',
      bio: document['bio'],
      avatarUrl: document['avatarUrl'],
    );
  }
}

