import 'package:flutter/material.dart';
import 'package:photo_quest/generated/l10n.dart';
import 'package:photo_quest/profilePage.dart';
import 'package:photo_quest/quest_controller.dart';
import 'QuestTab.dart';
import 'SettingsNavDrawer.dart';
class CollectionsPage extends StatefulWidget {
   const CollectionsPage({Key? key}) : super(key: key);
  @override
  State<CollectionsPage> createState() => _MyTabbedPageState();

}

class _MyTabbedPageState extends State<CollectionsPage> with SingleTickerProviderStateMixin {
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
        backgroundColor: Colors.pink[200],
        title: Text(S.of(context).collectionsLabel),
        centerTitle: true,

        actions: [
          Builder(builder: (context) => IconButton(
            icon: Icon(Icons.person),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context)=> ProfilePage()
              )
              );
            },
          )


          )
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        )
      ),
      body: QuestController().buildCollection(context),
      drawer: SettingsNavBar(),
    );
  }
}