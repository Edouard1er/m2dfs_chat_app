import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2dfs_chat_app/constants.dart';

class MessageItem extends StatelessWidget {
  final String text;
  final String senderId;
  final DateTime date;
  final bool isSent;

   const MessageItem({
    Key? key,
    required this.text,
    required this.senderId,
    required this.date,
    required this.isSent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Insets.xs),
      child: Align(
        alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: isSent ? KColors.sentMessageGreen : KColors.primaryColor,
            borderRadius: BorderRadius.circular(Insets.xs),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Insets.small),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: Insets.medium,
                    ),
                  ),
                ),
                const SizedBox(height: 1.0),
                Padding(
                  padding: const EdgeInsets.only(right: Insets.small, bottom: Insets.small),
                  child: Text(
                    _formatTime(date),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: Insets.small,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}
