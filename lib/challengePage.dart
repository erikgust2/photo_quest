import 'package:flutter/material.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({Key? key}) : super(key: key);
  @override
  State<ChallengePage> createState() => _MyTabbedPageState();

}

class _MyTabbedPageState extends State<ChallengePage> with SingleTickerProviderStateMixin {
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
            Tab(text: 'challengeDiscover'),
            Tab(text: 'challengeCompleted'),
          ],
        ),
      ),
    );
  }
}