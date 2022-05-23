import 'package:flutter/material.dart';
import 'package:photo_quest/generated/l10n.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: AppBar(
        title: Text(S.of(context).profileLabel),
        backgroundColor: Colors.pink[200],

      ),
      body: Center(child: Text(S.of(context).profilePlaceholder)),
    );
  }
}
