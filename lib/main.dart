import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/chat_app.dart';
import 'package:m2dfs_chat_app/viewmodel/auth_viewmodel.dart';
import 'package:m2dfs_chat_app/viewmodel/chat_user_viewmodel.dart';
import 'package:m2dfs_chat_app/viewmodel/chat_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthViewModel>(
              create: (_) => AuthViewModel(
                  firebaseFirestore: firebaseFirestore,
                  prefs: prefs,
                  firebaseAuth: FirebaseAuth.instance)
          ),
        ],
        child: const ChatApp(),
      ),
  );
}
