import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/chat_app.dart';
import 'package:m2dfs_chat_app/model/chat_user.dart';
import 'package:m2dfs_chat_app/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../viewmodel/chat_user_viewmodel.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController? displayNameController;
  TextEditingController? bioController;

  late String currentUserId;
  String id = '';
  String displayName = '';
  String bio = '';

  bool isLoading = false;
  late ChatUserViewModel chatUserViewModel;

  final FocusNode focusDisplayName = FocusNode();

  @override
  void initState() {
    super.initState();
    chatUserViewModel = context.read<ChatUserViewModel>();
    getPrefData();
  }

  void getPrefData() {
    setState(() {
      id = chatUserViewModel.getPrefs("id") ?? "";
      displayName = chatUserViewModel.getPrefs("displayName") ?? "";

      bio = chatUserViewModel.getPrefs("bio") ?? "";
    });
    displayNameController = TextEditingController(text: displayName);
    bioController = TextEditingController(text: bio);
  }



  void updateProfile() {
    focusDisplayName.unfocus();
    setState(() {
      isLoading = true;
    });

    ChatUser user = ChatUser(id: id, displayName: displayName, bio: bio);
    chatUserViewModel.updateCurrentUser(id, user.toJson())
        .then((value) async {
      await chatUserViewModel.setPrefs("displayName", displayName);
      await chatUserViewModel.setPrefs("bio", bio);

      setState(() {
        isLoading = false;
      });

      if(context.mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    }).catchError((onError) {
      print("Update Info error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: const Text(
            KProfilePageTitle,
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Nom complet', style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),),
                      TextField(

                        controller: displayNameController,
                        onChanged: (value) {
                          displayName = value;
                        },
                        focusNode: focusDisplayName,
                      ),
                      const SizedBox(height: Insets.medium),
                      const Text('Bio', style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                      ),),
                      TextField(
                        onChanged: (value) {
                          bio = value;
                        },
                      ),
                      const SizedBox(height: Insets.medium),

                      const SizedBox(height: Insets.medium),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        updateProfile();
                      },
                      child:const Padding(
                    padding:  EdgeInsets.all(8.0),
                    child:  Text('Enregistrer'),
                  )),

                ],
              ),
            ),
            Positioned(child: isLoading ? const LoadingScreen() : const SizedBox.shrink()),
          ],
        ),

      );
  }
}
