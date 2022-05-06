import 'package:flutter/material.dart';
import 'package:photo_quest/searchPage.dart';

/// This is a very simple class, used to
/// demo the `SearchPage` package
class Quest {
  final String name, area;

  Quest(this.name, this.area);
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
  static List<Quest> quests = [
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
          final Quest quest = quests[index];
          return ListTile(
            title: Text(quest.name),
            subtitle: Text(quest.area),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search quests',
        onPressed: () => showSearch(
          context: context,
          delegate: SearchPage<Quest>(
            items: quests,
            searchLabel: 'Search quests',
            suggestion: Center(
              child: Text('Filter quests by type'),
            ),
            failure: Center(
              child: Text('No quest found :('),
            ),
            filter: (quest) => [
              quest.name,
              quest.area,
            ],
            builder: (quest) => ListTile(
              title: Text(quest.name),
              subtitle: Text(quest.area),
            ),
          ),
        ),
        child: Icon(Icons.search),
      ),
    );
  }
}