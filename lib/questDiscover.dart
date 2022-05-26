import 'package:flutter/material.dart';

import 'MapNode.dart';



class QuestDiscover {
  final String name, area;

  QuestDiscover(this.name, this.area);
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'search_page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  static List<MapNode> quests = [
     //input quests
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: ListView.builder(
        itemCount: quests.length,
        itemBuilder: (context, index) {
          final MapNode quest = quests[index];
          return ListTile(
            title: Text(quest.name),
            subtitle: Text(quest.description),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search quests',
        onPressed: () {  },
        child: Icon(Icons.search),
      ),
    );
  }
}