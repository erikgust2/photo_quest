import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.pink[200],

      ),
      body: Center(child: Text('This is the center of the profile Page')),
    );
  }
}
