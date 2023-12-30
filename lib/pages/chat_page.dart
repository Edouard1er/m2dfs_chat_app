import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/constants.dart';
import 'package:m2dfs_chat_app/viewmodel/auth_viewmodel.dart'; // Importez votre AuthViewModel
import 'package:m2dfs_chat_app/widgets/new_message_section.dart';
import 'package:provider/provider.dart';

import '../viewmodel/chat_view_model.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String? receiverAvatar;
  final String receiverName;

  ChatPage({
    Key? key,
    required this.receiverId,
    required this.receiverAvatar,
    required this.receiverName,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String senderAvatar;
  late AuthViewModel authViewModel;
  late ChatViewModel chatViewModel;

  @override
  void initState() {
    super.initState();
    authViewModel = context.read<AuthViewModel>();
    senderAvatar = authViewModel.getCurrentUserAvatarUrl() ?? kDefaultAvatar;
    chatViewModel = ChatViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.whatsappGreyColor,
      appBar: AppBar(
        title: Text(widget.receiverName,
        style: const TextStyle(color: KColors.primaryColor)),
        backgroundColor: KColors.whatsappGreen,
        iconTheme: const IconThemeData(
          color: KColors.primaryColor,
        ),
      ),
      body: Column(
        children: [
          const Expanded(
            child: Center(),
          ),
          NewMessageSection(receiverId: widget.receiverId),
        ],
      ),
    );
  }
}
