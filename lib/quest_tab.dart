import 'package:flutter/material.dart';
import 'package:photo_quest/generated/l10n.dart';
import 'package:photo_quest/quest_view.dart';
import 'package:photo_quest/themes.dart';
import 'completed_quests.dart';
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
            borderRadius: BorderRadius.circular(10),
            
            color: VANILLA_ICE.withOpacity(0.2)
          ),
          controller: _tabController,
          tabs: [
            Tab(child: Container(decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),

            ),
              child:  Align(alignment: Alignment.center,
                child: Text(S.of(context).availableLabel, style: TextStyle(color: VANILLA_ICE),)),
            ),
            ),
            Tab(child: Container(decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),

            ),
              child:  Align(alignment: Alignment.center,
                  child: Text(S.of(context).completedLabel, style: TextStyle(color: VANILLA_ICE),)),
            ),
            ),
          ],
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children:  [
            QuestBox(),
            QuestCompleted(),
          ]
      ),
    );
  }
}