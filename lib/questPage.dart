import 'package:flutter/material.dart';
import 'questJoined.dart';
class QuestPage extends StatefulWidget {
   const QuestPage({Key? key}) : super(key: key);
  @override
  State<QuestPage> createState() => _MyTabbedPageState();

}

class _MyTabbedPageState extends State<QuestPage> with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'LEFT'),
    Tab(text: 'RIGHT'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: TabBar(
          controller: _tabController,

          tabs: [
            Tab(text: 'Discover'),
            Tab(text: 'Joined'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
          children: [Text("Discover"), QuestJoined()

          ]
      ),
    );
  }
}