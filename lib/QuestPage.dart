import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:photo_quest/QuestTab.dart';
import 'package:photo_quest/generated/l10n.dart';
import 'package:photo_quest/goldenHour.dart';
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

          title: Column(children: const [
            Text('Quests',
              style: TextStyle(color: Colors.white, fontSize: 22.0),),
            Text('Countdown',
              style: TextStyle(color: Colors.white, fontSize: 12.0),)
          ],),

          //title: Text(S.of(context).questLabel),


          actions: [
            Builder(builder: (context) =>
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ProfilePage()
                    )
                    );
                  },
                )

            )
          ],
          leading: Builder(
            builder: (context) =>
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
          )
      ),
      drawer: const SettingsNavBar(),
      body: const QuestTab(),
    );
  }

}