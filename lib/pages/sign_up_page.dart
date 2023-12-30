import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/chat_app.dart';
import 'package:m2dfs_chat_app/pages/login_page.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../viewmodel/auth_viewmodel.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _passwordConfirmFieldController = TextEditingController();
  final _nameController = TextEditingController();
  bool _showPassword = false;
  bool _showPasswordConfirm = false;

  isPasswordMatch() {
    if (_passwordFieldController.text == _passwordConfirmFieldController.text) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Scaffold(

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Insets.medium),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Créez votre compte EddyChat',
                        style: theme.textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Insets.extraLarge),
                      const Text(
                        'Nom',
                        textAlign: TextAlign.center,
                      ),
                      TextFormField(
                        controller: _nameController,
                        autofillHints: const [AutofillHints.name],
                        decoration: KDecorations.inputDecoration.copyWith(
                          hintText: 'Entrez votre nom',
                        ),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                        value != null && value.isNotEmpty
                            ? null
                            : 'Nom invalide',
                      ),
                      const SizedBox(height: Insets.extraLarge),
                      const Text(
                        'Email',
                        textAlign: TextAlign.center,
                      ),
                      TextFormField(
                        controller: _emailFieldController,
                        autofillHints: const [AutofillHints.email],
                        decoration: KDecorations.inputDecoration.copyWith(
                          hintText: 'Entrez votre email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                        value != null && EmailValidator.validate(value)
                            ? null
                            : 'Email invalide',
                      ),
                      const SizedBox(height: Insets.medium),
                      const Text(
                        'Mot de passe',
                        textAlign: TextAlign.center,
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return TextFormField(
                            controller: _passwordFieldController,
                            autofillHints: const [AutofillHints.password],
                            obscureText: !_showPassword,
                            decoration: KDecorations.inputDecoration.copyWith(
                              hintText: 'Entrez votre mot de passe',
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                        () => _showPassword = !_showPassword),
                                icon: _showPassword
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                              ),
                              ),
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                          );
                        },
                      ),
                      const SizedBox(height: Insets.medium),
                      const Text(
                        'Confirmer le mot de passe',
                        textAlign: TextAlign.center,
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return TextFormField(
                            controller: _passwordConfirmFieldController,
                            autofillHints: const [AutofillHints.password],
                            obscureText: !_showPasswordConfirm,
                            decoration: KDecorations.inputDecoration.copyWith(
                              hintText: 'Confirmez votre mot de passe',
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                        () => _showPasswordConfirm = !_showPasswordConfirm),
                                icon: _showPasswordConfirm
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                          );
                        },
                      ),
                      const SizedBox(height: Insets.medium),
                      Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: KColors.buttonWhatsappGreen, // Couleur de fond vert pâle
                              foregroundColor: KColors.primaryColor,    // Couleur du texte en noir
                              padding: const EdgeInsets.all(Insets.small),
                            ),
                          onPressed: () async {
                            if(!isPasswordMatch()){
                              scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Les mots de passe ne correspondent pas")));
                              return;
                            }
                            bool isSuccess = await authViewModel.signUp(_nameController.text, _emailFieldController.text, _passwordFieldController.text);
                            if(context.mounted){
                              if (isSuccess) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const ChatApp())
                                );
                              }
                              scaffoldMessenger.showSnackBar( SnackBar(content: Text(authViewModel.getPrefs("signUpErrorMessage") ?? "Erreur")));
                            }
                          },
                          child: const Text('S\'inscrire'),
                        ),
                      ),
                      const SizedBox(height: Insets.medium),
                      const Text(
                        'Vous avez déjà un compte ?',
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) =>  LoginPage())),
                        child: const Text('Se connecter', style: TextStyle(color: KColors.whatsappGreen)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
