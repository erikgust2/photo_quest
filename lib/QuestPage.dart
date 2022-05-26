import 'package:flutter/material.dart';
import 'package:photo_quest/QuestTab.dart';
import 'package:photo_quest/generated/l10n.dart';
import 'SettingsNavDrawer.dart';
import 'profilePage.dart';
import 'QuestTab.dart';
import 'goldenHour.dart';
class QuestPage extends StatelessWidget {
  const QuestPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink[200],

        title: Column(children: [
          Text('Quests',
            style: TextStyle(color: Colors.white, fontSize: 22.0),),
          Text('Countdown',
              style: TextStyle(color: Colors.white, fontSize: 12.0),),
            Text(S.of(context).questLabel),
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