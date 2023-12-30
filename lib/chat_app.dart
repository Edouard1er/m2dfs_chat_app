import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'widgets/loading_screen.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppTitle,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
          backgroundColor: Colors.white,
          accentColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
      ),
      home: isLoggedIn ?  const HomePage() :  const LoginPage(),
    );
  }
}

