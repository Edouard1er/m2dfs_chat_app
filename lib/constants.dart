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
}

class KColors {
  static const Color whatsappGreen = Color(0xFF25D366);
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
}

const kDefaultAvatar = "assets/messi.jpg";
