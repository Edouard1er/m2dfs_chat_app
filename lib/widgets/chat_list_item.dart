import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/constants.dart';
import 'package:m2dfs_chat_app/pages/chat_page.dart';

class ChatListItem extends StatelessWidget {
  final String id;
  final String displayName;
  final String lastMessage;
  final String? avatarUrl;

  const ChatListItem({super.key, required this.displayName, required this.lastMessage, this.avatarUrl, required this.id});

  @override
  Widget build(BuildContext context) {

    Widget avatarWidget;

    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      avatarWidget = CircleAvatar(
        backgroundImage: NetworkImage(avatarUrl!),
      );
    } else {
      avatarWidget = const CircleAvatar(
        backgroundImage: AssetImage(kDefaultAvatar),
      );
    }

    return ListTile(
      tileColor: Colors.white,
      leading: avatarWidget,
      title: Text(displayName),
      subtitle: Text(lastMessage),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(receiverId: id, receiverAvatar: avatarUrl, receiverName: displayName))
        );
      },
    );
  }
}
