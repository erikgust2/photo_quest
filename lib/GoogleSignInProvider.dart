import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!; //getter method for the google user

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser; //assigns _user with the logged in google user

    final googleAuth = await googleUser.authentication; //get the google authentication for logged in user

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    ); //credentials used for firebase authentication

    await FirebaseAuth.instance.signInWithCredential((credential)); //firebase log in authentication

    notifyListeners(); //update UI
  }
}
