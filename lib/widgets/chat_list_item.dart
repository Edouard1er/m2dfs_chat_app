import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/constants.dart';

class ChatListItem extends StatelessWidget {
  final String displayName;
  final String lastMessage;
  final String? avatarUrl;

  const ChatListItem({super.key, required this.displayName, required this.lastMessage, this.avatarUrl});

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
        print("Et oui, on va vers la conversation !!! C'est un peu difficcccccciiiiiiilllllleeeeee! lol");
      },
    );
  }
}
