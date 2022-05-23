import 'package:flutter/material.dart';
import 'package:photo_quest/QuestTab.dart';
import 'package:photo_quest/generated/l10n.dart';
import 'SettingsNavDrawer.dart';
import 'profilePage.dart';
import 'QuestTab.dart';
class QuestPage extends StatelessWidget {
  const QuestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink[200],
        title: Text(S.of(context).questLabel),

          actions: [
            Builder(builder: (context) => IconButton(
              icon: Icon(Icons.person),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> const ProfilePage()
                )
                );
              },
            )

            )
          ],
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          )
      ),
      drawer: const SettingsNavBar(),
      body: QuestTab(),
    );
  }
}