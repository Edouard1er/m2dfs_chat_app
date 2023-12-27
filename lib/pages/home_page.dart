import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eddy Chat App'),
      ),
      body: const Center(
        child: Text('Ici, je vais afficher la liste des discussions. Restez branchés ! Haha!'),
      ),
    );
  }
}