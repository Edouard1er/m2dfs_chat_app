import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/chat_app.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ChatApp());
}