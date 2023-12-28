import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/pages/profile_page.dart';
import 'package:provider/provider.dart';

import '../chat_app.dart';
import '../constants.dart';
import '../viewmodel/auth_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppTitle),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.signOut();
              if(context.mounted){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ChatApp()),
                );
              }
            },
          ),
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
      body: Center()
    );
  }
}
