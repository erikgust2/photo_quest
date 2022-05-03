import 'package:flutter/material.dart';

class QuestPage extends StatefulWidget {
   QuestPage({Key? key}) : super(key: key);
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
        title: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Discover'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
    );
  }
}