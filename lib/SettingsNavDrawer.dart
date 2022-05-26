import 'package:flutter/material.dart';
import 'package:photo_quest/ColorsPage.dart';
import 'package:photo_quest/generated/l10n.dart';
import 'LanguagePage.dart';

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
        title:  Text(S.of(context).languageLabel),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context)=> const LanguagePage()
          )
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.palette_outlined),
        title: Text(S.of(context).colorsLabel),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context)=> const ColorsPage()
          )
          );},
      ),
      ListTile(
        leading: const Icon(Icons.supervisor_account),
        title: Text(S.of(context).accountSettingsLabel),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.article_outlined),
        title: Text(S.of(context).userAgreementLabel),
        onTap: () {},
      ),
    ],

  );
}