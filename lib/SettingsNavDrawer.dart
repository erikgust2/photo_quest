import 'package:flutter/material.dart';

class SettingsNavBar extends StatelessWidget{
  const SettingsNavBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget> [
          buildHeader(context),
          buildMenuItems(context)
        ],
      ),
    ),
  );
  Widget buildHeader(BuildContext context) => Container(
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top
    ),
  );
  Widget buildMenuItems(BuildContext context) => Column(
    children: [
      ListTile(
        leading: const Icon(Icons.language),
        title: const Text('Language'),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.palette_outlined),
        title: const Text('Colors'),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.supervisor_account),
        title: const Text('Account Settings'),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.article_outlined),
        title: const Text('User Agreement'),
        onTap: () {},
      ),
    ],

  );
}