class Chat {
  String id;
  List<String> users;

  Chat({
    required this.id,
    required this.users,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] ?? '',
      users: List<String>.from(json['users'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'users': users,
    };
  }

  factory Chat.fromDocument(Map<String, dynamic> document) {
    return Chat(
      id: document['id'] ?? '',
      users: List<String>.from(document['users'] ?? []),
    );
  }
}
