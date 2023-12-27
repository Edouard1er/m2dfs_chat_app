import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'widgets/loading_screen.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Ici, on attend que la connexion soit établie
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else {
            // Ben là, on a soit un utilisateur connecté, soit un utilisateur déconnecté
            if (snapshot.hasData) {
              // Utilisateur connecté, Eddy affiche l'écran d'accueil
              return HomePage();
            } else {
              // Utilisateur déconnecté, Eddy affiche l'écran de connexion
              return LoginPage();
            }
          }
        },
      ),
    );
  }
}

