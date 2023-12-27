import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/chat_app.dart';
import 'package:m2dfs_chat_app/model/chat_user.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../controller/user_authentification.dart';
import '../viewmodel/chat_user_viewmodel.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ChatUser? _currentUser;
  late ChatUserViewModel _chatUserViewModel;

  @override
  void initState() {
    super.initState();
    _chatUserViewModel = Provider.of<ChatUserViewModel>(context, listen: false);
    _getDataForCurrentUser();
  }

  Future<void> _getDataForCurrentUser() async {
    _currentUser = await _chatUserViewModel.getDataForCurrentUser();
    if (mounted) {
      setState(() {});
    }
  }

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
                Text(_currentUser?.displayName ?? ''),
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
