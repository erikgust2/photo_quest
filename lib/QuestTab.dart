import 'package:flutter/material.dart';
import 'package:photo_quest/generated/l10n.dart';
import 'package:photo_quest/quest_box.dart';
import 'QuestCompleted.dart';
class QuestTab extends StatefulWidget {
  const QuestTab({Key? key}) : super(key: key);
  @override
  State<QuestTab> createState() => MyTabbedPageState();

}


class MyTabbedPageState extends State<QuestTab> with SingleTickerProviderStateMixin {
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
        automaticallyImplyLeading: false,
        title: TabBar(
          unselectedLabelColor: Colors.black,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            
            color: Colors.pink[300]
          ),
          controller: _tabController,
          tabs: [
            Tab(child: Container(decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),

            ),
              child:  Align(alignment: Alignment.center,
                child: Text(S.of(context).availableLabel, style: TextStyle(color: Colors.white),)),
            ),
            ),
            Tab(child: Container(decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),

            ),
              child:  Align(alignment: Alignment.center,
                  child: Text(S.of(context).completedLabel, style: TextStyle(color: Colors.white),)),
            ),
            ),
          ],
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: const [
            QuestBox(),
            QuestCompleted(),
          ]
      ),
    );
  }
}