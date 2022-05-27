import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_quest/GoogleSignInProvider.dart';
import 'package:photo_quest/QuestPage.dart';
import 'package:photo_quest/main.dart';
import 'package:provider/provider.dart';
import 'package:photo_quest/QuestPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LoginWidget extends StatelessWidget{
  const LoginWidget({Key? key}) : super(key: key);



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
      onPressed: () async {
        final provider = Provider.of<GoogleSignInProvider>(context, listen: false);      //
        provider.googleLogin();                                                          // detta används för att starta inloggningsprocessen
        print(FirebaseAuth.instance.currentUser?.email);

        final user = FirebaseAuth.instance.currentUser!;
        CollectionReference users = FirebaseFirestore.instance.collection('users');
        bool userExists = await checkIfUserExists(user.uid);

        if(!userExists){
          createNewUser(user, users);         //skapar en ny user i firestore om det inte redan finns en
        }

        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>  const MainScreen()));
      },
    );


  }

  void createNewUser(User user, CollectionReference users){
    users.doc(user.uid).set({'userID': user.uid, 'email': user.email});
  }

  Future<bool> checkIfUserExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('users');

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }


}