import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_quest/GoogleSignInProvider.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.black,
        minimumSize: Size(double.infinity, 50),
      ),
      icon: FaIcon(FontAwesomeIcons.google), //FontAwesome innehåller google ikonen
      label: Text('Log in with Google'),
      onPressed: () {
        final provider = Provider.of<GoogleSignInProvider>(context, listen: false);      //
        provider.googleLogin();                                                          // detta används för att starta inloggningsprocessen
        print(FirebaseAuth.instance.currentUser?.email);                                 //
      },
    );

  }


}