import 'package:flutter/material.dart';

class QuestJoined extends StatefulWidget {
  const QuestJoined({Key? key}) : super(key: key);
  @override
  State<QuestJoined> createState() => _MyTabbedPageState();

}

class _MyTabbedPageState extends State<QuestJoined> with SingleTickerProviderStateMixin {
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
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: TabBar(
          unselectedLabelColor: Colors.black,

          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            
            color: Colors.pink[100]
          ),
          controller: _tabController,
          tabs: [
            Tab(child: Container(decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),

            ),
              child: const Align(alignment: Alignment.center,
                child: Text("Active", style: TextStyle(color: Colors.black),)),
            ),
            ),
            Tab(child: Container(decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),

            ),
              child: const Align(alignment: Alignment.center,
                  child: Text("Completed", style: TextStyle(color: Colors.black),)),
            ),
            ),
          ],
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: const [
            Text('Active'), Text('Completed',)
          ]
      ),
    );
  }
}