import 'package:flutter/material.dart';

import '../constants.dart';
import '../viewmodel/chat_view_model.dart';

class NewMessageSection extends StatefulWidget {
  final String receiverId;
  final String chatId;
  final String senderId;

  const NewMessageSection({Key? key, required this.chatId, required this.receiverId, required this.senderId} ) : super(key: key);

  @override
  NewMessageWidgetState createState() => NewMessageWidgetState();
}

class NewMessageWidgetState extends State<NewMessageSection> {
  final TextEditingController _messageController = TextEditingController();
  late ChatViewModel chatViewModel;

  @override
  void initState() {
    super.initState();
    chatViewModel = ChatViewModel();
  }

  void _sendMessage() async {
    final String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      await chatViewModel.sendNewMessage(
        chatId: widget.chatId,
        from: widget.senderId,
        to: widget.receiverId,
        content: text,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.xs),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Insets.extraLarge),
                color: KColors.primaryColor
              ),
              child: TextField(
                controller: _messageController,
                maxLines: 5,
                minLines: 1,
                decoration: KDecorations.focusedInputMessageDecoration.copyWith(
                  hintText: 'Message...',
                ),
                style: const TextStyle(
                  color: KColors.secondaryColor,
                ),
                textCapitalization: TextCapitalization.sentences
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: Insets.xxs),
            decoration: BoxDecoration(
              color: KColors.buttonWhatsappGreen,
              borderRadius: BorderRadius.circular(Insets.superExtraLarge),
            ),
            child: IconButton(
              onPressed: () {
                _sendMessage();
              },
              icon: const Icon(Icons.send_rounded),
              color: KColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
