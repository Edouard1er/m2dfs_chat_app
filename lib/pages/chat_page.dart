import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/constants.dart';
import 'package:provider/provider.dart';

import '../viewmodel/auth_viewmodel.dart';

class ChatPage extends StatefulWidget {
  String receiverId;
  String? receiverAvatar;
  String receiverName;

  ChatPage({
    Key? key,
    required this.receiverId,
    required this.receiverAvatar,
    required this.receiverName
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String senderAvatar;
  late AuthViewModel authViewModel;

  @override
  void initState() {
    super.initState();
    authViewModel = context.read<AuthViewModel>();
    senderAvatar = authViewModel.getCurrentUserAvatarUrl() ?? kDefaultAvatar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
      ),
      body: const Center(
      ),
    );
  }
}
