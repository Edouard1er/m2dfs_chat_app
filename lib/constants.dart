import 'package:flutter/material.dart';

const kAppTitle = 'EddyChat';
const kProfilePageTitle = 'Profil';

class Insets {
  static const double xxs = 4;
  static const double xs = 8;
  static const double small = 12;
  static const double medium = 16;
  static const double large = 18;
  static const double extraLarge = 22;
  static const double superExtraLarge = 35;
}

class KColors {
  static const Color whatsappGreen = Color(0xFF008069);
  static const Color buttonWhatsappGreen = Color(0xFF02a884);
  static const Color sentMessageGreen = Color(0xFFe7ffdb);
  static const Color primaryColor = Colors.white;
  static const Color secondaryColor = Colors.black;
  static const Color whatsappGreyColor = Color(0xFFEEEEEE);
}

class KDecorations {
  static InputDecoration focusedInputDecoration = InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: KColors.whatsappGreen, width: 2.0),
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: KColors.whatsappGreen, width: 2.0),
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  static InputDecoration focusedInputMessageDecoration = InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.circular(25.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.circular(25.0),
    ),
  );
}

const kDefaultAvatar = "assets/messi.jpg";

const kChatCollection = 'chats';
const kUsersCollection = 'users';
const kMessagesCollection = 'messages';
