import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/chat_app.dart';

import '../constants.dart';
import '../controller/user_authentification.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.medium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Ici, je vais afficher les informations de l'utilisateur connecté.!"),
                const SizedBox(height: Insets.medium),
                TextButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      if(context.mounted){
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const ChatApp()),
                        );
                      }
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: const Text('Déconnexion'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
