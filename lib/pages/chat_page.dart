import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2dfs_chat_app/constants.dart';
import 'package:m2dfs_chat_app/viewmodel/auth_viewmodel.dart';
import 'package:m2dfs_chat_app/widgets/loading_screen.dart';
import 'package:m2dfs_chat_app/widgets/new_message_section.dart';
import 'package:provider/provider.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:collection/collection.dart';

import '../model/Message.dart';
import '../viewmodel/chat_view_model.dart';
import '../widgets/message_item.dart';

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
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: chatViewModel.getTwoUserChatMessages(chatId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final messages = snapshot.data ?? [];

                  final groupedMessages = groupBy(messages, (Message message) {
                    return DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(int.parse(message.timestamp)));
                  });

                  return GroupedListView<dynamic, String>(
                    elements: groupedMessages.entries.toList(),
                    groupBy: (element) => element.key,
                    groupSeparatorBuilder: (String value) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                    itemBuilder: (context, messagesGrouped) {
                      final List<Message> sortedMessages = messagesGrouped.value
                        ..sort((Message a, Message b) => a.timestamp.compareTo(b.timestamp));

                      final List<MessageItem> messageItems = [];

                      for (var message in sortedMessages) {
                        final messageItem = MessageItem(
                          text: message.content,
                          senderId: message.from,
                          date: DateTime.fromMillisecondsSinceEpoch(int.parse(message.timestamp)),
                          isSent: message.from == senderId,
                        );

                        messageItems.add(messageItem);
                      }

                      return Column(
                        children: messageItems,
                      );
                    },
                  );
                }
              },
            ),
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

