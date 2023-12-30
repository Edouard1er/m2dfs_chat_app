import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/constants.dart';
import 'package:m2dfs_chat_app/viewmodel/auth_viewmodel.dart';
import 'package:m2dfs_chat_app/widgets/loading_screen.dart';
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
  String? chatId;
  late String senderId;

  @override
  void initState() {
    super.initState();
    authViewModel = context.read<AuthViewModel>();
    senderAvatar = authViewModel.getCurrentUserAvatarUrl() ?? kDefaultAvatar;
    senderId = authViewModel.getCurrentUserId() ?? "";
    chatViewModel = ChatViewModel();

    chatViewModel.getChat(senderId, widget.receiverId).then((id) {
      setState(() {
        chatId = id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (chatId == null) {
      return const LoadingScreen();
    }

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
          NewMessageSection(
            chatId: chatId!,
            receiverId: widget.receiverId,
            senderId: senderId,
          ),
        ],
      ),
    );
  }
}

