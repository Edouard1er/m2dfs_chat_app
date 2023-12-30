import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/model/chat_user.dart';
import 'package:m2dfs_chat_app/pages/profile_page.dart';
import 'package:m2dfs_chat_app/widgets/chat_list_item.dart';
import 'package:m2dfs_chat_app/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

import '../chat_app.dart';
import '../constants.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../viewmodel/chat_user_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final chatUserViewModel = Provider.of<ChatUserViewModel>(context);
    final avatarUrl = authViewModel.getCurrentUserAvatarUrl();
    Widget avatarWidget;

    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      avatarWidget = CircleAvatar(
        backgroundImage: NetworkImage(avatarUrl!),
      );
    } else {
      avatarWidget = const CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 20,
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
      );
    }

    return Scaffold(
      backgroundColor: KColors.primaryColor,
      appBar: AppBar(
        title: const Text(kAppTitle,
        style: TextStyle(color: KColors.primaryColor)),
        backgroundColor: KColors.whatsappGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: KColors.primaryColor,
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
              child: avatarWidget,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: chatUserViewModel.getUserList(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final users = snapshot.data?.docs ?? [];
            final chatUsers = users.map((doc) => ChatUser.fromDocument(doc)).toList();

            final currentUserID = authViewModel.getCurrentUserId();

            final filteredChatUsers = chatUsers.where((user) => user.id != currentUserID).toList();
            if (filteredChatUsers.isNotEmpty) {

            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                height: 2,
              ),
              itemCount: filteredChatUsers.length,
              itemBuilder: (context, index) {
                final ChatUser user = filteredChatUsers[index];
                return ChatListItem(displayName: user.displayName ?? "", lastMessage: "Taper pour écrire...", avatarUrl: user.avatarUrl, id: user!.id,);
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
