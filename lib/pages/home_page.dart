import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/model/chat_user.dart';
import 'package:m2dfs_chat_app/pages/profile_page.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../controller/user_authentification.dart';
import '../viewmodel/chat_user_viewmodel.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final UserAuthentication userAuth = UserAuthentication();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppTitle),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10.0),
              child: const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
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
