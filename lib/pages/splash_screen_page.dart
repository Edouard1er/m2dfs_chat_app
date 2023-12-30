import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/chat_app.dart';
import 'package:m2dfs_chat_app/pages/home_page.dart';
import 'package:m2dfs_chat_app/pages/login_page.dart';

import '../constants.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
          () {
            final isLoggedIn = FirebaseAuth.instance.currentUser != null;
            Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => isLoggedIn ? const HomePage() : const LoginPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_chat_app.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 16),
            const Text(
              'Bienvenue à $kAppTitle',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
