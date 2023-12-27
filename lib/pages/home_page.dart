import 'package:flutter/material.dart';

import '../controller/user_authentification.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final UserAuthentication userAuth = UserAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eddy Chat App'),
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Ici, je vais afficher la liste des discussions. Restez branchés ! Haha!'),
            ElevatedButton(
              onPressed: () async {
                await userAuth.signOut();
              },
              child: const Text('Déconnexion'),
            ),
          ],
        ),
      ),
    );
  }
}