import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/model/chat_user.dart';
import 'package:m2dfs_chat_app/pages/profile_page.dart';
import 'package:m2dfs_chat_app/widgets/chat_list_item.dart';
import 'package:provider/provider.dart';

import '../chat_app.dart';
import '../constants.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../viewmodel/chat_user_viewmodel.dart'; // Importez votre ChatUserViewModel

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final chatUserViewModel = Provider.of<ChatUserViewModel>(context); // Obtenez votre ChatUserViewModel

    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppTitle),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.signOut();
              if (context.mounted) {
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
      body: StreamBuilder(
        stream: chatUserViewModel.getUserList(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final users = snapshot.data?.docs ?? [];
            final chatUsers = users.map((doc) => ChatUser.fromDocument(doc)).toList();

            final currentUserID = authViewModel.getFirebaseUserId();

            final filteredChatUsers = chatUsers.where((user) => user.id != currentUserID).toList();
            if (filteredChatUsers.isNotEmpty) {

            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                height: 2,
              ),
              itemCount: filteredChatUsers.length,
              itemBuilder: (context, index) {
                final ChatUser user = filteredChatUsers[index];
                return ChatListItem(displayName: user.displayName ?? "", lastMessage: "Test", avatarUrl: user.avatarUrl);
              },
            );
            }else {
              return const Center(
                child: Text('Aucun utilisateur trouvé dude...'),
              );
            }
          }
        },
      ),


    );
  }
}
