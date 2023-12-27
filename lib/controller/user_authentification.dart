import 'package:firebase_auth/firebase_auth.dart';

class UserAuthentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp(String emailAddress, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Ici, on va utiliser une dialog box pour afficher le message d'erreur selon le type, mais pour le moment, restons concentrés sur l'essentiel
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }else{
        print(e.message);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signIn(String emailAddress, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Ici, on va utiliser une dialog box pour afficher le message d'erreur selon le type, mais pour le moment, restons concentrés sur l'essentiel
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }else{
        print(e.message);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
