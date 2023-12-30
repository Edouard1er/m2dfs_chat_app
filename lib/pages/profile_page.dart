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
    chatUserViewModel.updateCurrentUser(id, user.toJson()).then((value) async {
      await chatUserViewModel.setPrefs("displayName", displayName);
      await chatUserViewModel.setPrefs("bio", bio);

      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          kProfilePageTitle,
          style: TextStyle(color: KColors.primaryColor),
        ),
        iconTheme: const IconThemeData(
          color: KColors.primaryColor,
        ),
        backgroundColor: KColors.whatsappGreen,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(Insets.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Nom complet',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    TextField(
                      controller: displayNameController,
                      onChanged: (value) {
                        displayName = value;
                      },
                      focusNode: focusDisplayName,
                      decoration: KDecorations.focusedInputDecoration.copyWith(
                        hintText: 'Entrez votre nom complet',
                      ),
                    ),
                    const SizedBox(height: Insets.medium),
                    const Text(
                      'Bio',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: bioController,
                      onChanged: (value) {
                        bio = value;
                      },
                      decoration: KDecorations.focusedInputDecoration.copyWith(
                        hintText: 'Entrez votre bio',
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: Insets.medium),
                  ],
                ),
                ElevatedButton(
                  onPressed: updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KColors.buttonWhatsappGreen, // Couleur de fond vert pâle
                    foregroundColor: KColors.primaryColor,    // Couleur du texte en noir
                    padding: const EdgeInsets.all(Insets.medium),
                  ),
                  child: const Text(
                    'Enregistrer',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: Insets.medium),
              ],
            ),
          ),
          Positioned(
            child: isLoading ? const LoadingScreen() : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
