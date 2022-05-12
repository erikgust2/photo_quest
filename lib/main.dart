import 'package:flutter/material.dart';
import 'CollectionsPage.dart';
import 'QuestPage.dart';
import 'questMap.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'PhotoQuest';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
        debugShowCheckedModeBanner: false
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final screens = [
    const QuestPage(),
    const QuestMapPage(),
    const CollectionsPage(),

  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: screens [_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pink[100],
        type:BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_police_outlined),
            label: 'Quests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Collections',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}


