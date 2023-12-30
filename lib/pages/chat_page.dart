import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2dfs_chat_app/constants.dart';
import 'package:m2dfs_chat_app/viewmodel/auth_viewmodel.dart';
import 'package:m2dfs_chat_app/widgets/loading_screen.dart';
import 'package:m2dfs_chat_app/widgets/new_message_section.dart';
import 'package:provider/provider.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:collection/collection.dart';
import 'package:intl/date_symbol_data_local.dart';

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
    initializeDateFormatting('fr_FR', null);
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


  String formatCalendarDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final lastWeek = DateTime.now().subtract(const Duration(days: 7));

    if (DateFormat('yyyyMMdd', 'fr_FR').format(date) == DateFormat('yyyyMMdd', 'fr_FR').format(now)) {
      return 'Aujourd\'hui';
    } else if (DateFormat('yyyyMMdd', 'fr_FR').format(date) == DateFormat('yyyyMMdd', 'fr_FR').format(yesterday)) {
      return 'Hier';
    } else if (date.isAfter(lastWeek)) {
      return DateFormat.EEEE('fr_FR').format(date);
    } else {
      return DateFormat('dd/MM/yyyy', 'fr_FR').format(date);
    }
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
                    return DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(int.parse(message.timestamp)));
                  });

                  return GroupedListView<dynamic, String>(
                    padding: const EdgeInsets.only(top: Insets.xs),
                    elements: groupedMessages.entries.toList(),
                    groupBy: (element) => element.key,
                    reverse: true,
                    order: GroupedListOrder.DESC,
                    groupSeparatorBuilder: (String value) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: KColors.whatsappDateBgColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            formatCalendarDate(DateTime.parse(value)),
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

