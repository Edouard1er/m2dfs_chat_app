import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:m2dfs_chat_app/chat_app.dart';
import 'package:m2dfs_chat_app/pages/sign_up_page.dart';
import 'package:m2dfs_chat_app/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

import '../constants.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  bool _showPassword = false;

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
                        'Connectez-vous à votre compte $kAppTitle',
                        style: theme.textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Insets.extraLarge),
                      const Text(
                        'Email',
                        textAlign: TextAlign.center,
                      ),
                      RepaintBoundary(
                        child: TextFormField(
                          controller: _emailFieldController,
                          autofillHints: const [AutofillHints.email],
                          decoration:  KDecorations.inputDecoration.copyWith(
                            hintText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                          value != null && EmailValidator.validate(value)
                              ? null
                              : 'Email invalide',
                        ),
                      ),
                      const SizedBox(height: Insets.medium),
                      const Text(
                        'Mot de passe',
                        textAlign: TextAlign.center,
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return RepaintBoundary(
                            child: TextFormField(
                              controller: _passwordFieldController,
                              autofillHints: const [AutofillHints.password],
                              obscureText: !_showPassword,
                              decoration: KDecorations.inputDecoration.copyWith(
                                hintText: 'Mot de passe',
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
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: Insets.medium),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: KColors.buttonWhatsappGreen, // Couleur de fond vert pâle
                            foregroundColor: KColors.primaryColor,    // Couleur du texte en noir
                            padding: const EdgeInsets.all(Insets.xs),
                          ),
                          onPressed: () async {
                            bool isSuccess = await authViewModel.signIn(_emailFieldController.text, _passwordFieldController.text);
                            if(context.mounted){
                              if (isSuccess) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const ChatApp())
                                );
                              }
                              scaffoldMessenger.showSnackBar( SnackBar(content: Text(authViewModel.getPrefs("signInErrorMessage") ?? "Erreur")));
                            }
                          },
                          child: const Text('Se connecter' ),
                        ),
                      ),
                      const SizedBox(height: Insets.medium),
                      const Text(
                        'Vous n\'avez pas de compte ?',
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) =>  const SignUpPage())),
                        child: const Text('S\'inscrire', style: TextStyle(color: KColors.whatsappGreen)),
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
