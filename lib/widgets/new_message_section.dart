import 'package:flutter/material.dart';

import '../constants.dart';
import '../viewmodel/chat_view_model.dart';

class NewMessageSection extends StatefulWidget {
  final String receiverId;

  const NewMessageSection({Key? key, required this.receiverId}) : super(key: key);

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
      print('message: $text');
      // Là je vais implémenter ma méthode pour envoyer le message tout en utilisant mon ChatViewModel
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
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
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              color: KColors.buttonWhatsappGreen,
              borderRadius: BorderRadius.circular(35),
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
