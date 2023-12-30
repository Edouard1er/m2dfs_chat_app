import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m2dfs_chat_app/chat_app.dart';
import 'package:m2dfs_chat_app/model/chat_user.dart';
import 'package:m2dfs_chat_app/widgets/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../viewmodel/chat_user_viewmodel.dart';

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
  String avatarUrl = '';

  bool isLoading = false;
  late ChatUserViewModel chatUserViewModel;

  File? avatarImageFile;

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
      avatarUrl = chatUserViewModel.getPrefs("avatarUrl") ?? "";
    });
    displayNameController = TextEditingController(text: displayName);
    bioController = TextEditingController(text: bio);
  }

  void updateProfile() {
    focusDisplayName.unfocus();
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> userMap = {
      'id': id,
      'displayName': displayName,
      'bio': bio
    };
    chatUserViewModel.updateCurrentUser(id, userMap).then((value) async {
      await chatUserViewModel.setPrefs("displayName", displayName);
      await chatUserViewModel.setPrefs("bio", bio);
      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        Navigator.pop(context);
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: onError.toString());
    });
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery)
        .catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString());
    });
    File? image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
      saveFile();
    }
  }

  Future saveFile() async {
    String fileName = id;
    UploadTask uploadTask = chatUserViewModel.uploadImageToFireStorage(
        avatarImageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      avatarUrl = await snapshot.ref.getDownloadURL();
      Map<String, dynamic> updateInfo = {
        'avatarUrl': avatarUrl,
      };
      chatUserViewModel.updateCurrentUser(
          id, updateInfo)
          .then((value) async {
        await chatUserViewModel.setPrefs("avatarUrl", avatarUrl);
        setState(() {
          isLoading = false;
        });
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.toString());
    }
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
                      GestureDetector(
                      onTap: getImage,
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(Insets.medium),
                        child: avatarImageFile == null ? avatarUrl.isNotEmpty ?
                        ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Image.network(avatarUrl,
                            fit: BoxFit.cover,
                            width: 140,
                            height: 140,
                            errorBuilder: (context, object, stackTrace) {
                              return const Icon(Icons.account_circle, size: 90,
                                color: KColors.whatsappGreen);
                            },
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return const SizedBox(
                                width: 90,
                                height: 90,
                                child: Center(
                                  child: LoadingScreen(),
                                ),
                              );
                            },
                          ),
                        ) : const Icon(Icons.account_circle,
                          size: 90,
                          color: KColors.whatsappGreen)
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.file(avatarImageFile!, width: 120,
                            height: 120,
                            fit: BoxFit.cover
                          ),
                        ),
                      ),
                    ),

                    const Text(
                      'Nom complet',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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
                        fontSize: 20,
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
