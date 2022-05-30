import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:photo_quest/quest_tab.dart';
import 'package:photo_quest/generated/l10n.dart';
import 'package:photo_quest/themes.dart';
import 'settings_drawer.dart';
import 'profile.dart';
import 'quest_tab.dart';
import 'golden_hour.dart';
class QuestPage extends StatelessWidget {
  const QuestPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          title: Column(children: [
          Text(S.of(context).questLabel,
            style: TextStyle(color: VANILLA_ICE, fontSize: 22.0),),
            GoldenHourController(),
          ],
        ),

          actions: [
            Builder(builder: (context) => IconButton(
              icon: Icon(Icons.person),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> ProfilePage()
                )
                );
              },
              color: VANILLA_ICE,
            )

            )
          ],
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openDrawer(),
              color: VANILLA_ICE,
            ),
          )
      ),
      drawer: const SettingsNavBar(),
      body: QuestTab(),
    );
  }
}