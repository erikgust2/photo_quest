import 'package:flutter/material.dart';
import 'package:photo_quest/profilePage.dart';
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
        title: Text('Collections'),
        centerTitle: true,

        actions: [
          Builder(builder: (context) => IconButton(
            icon: Icon(Icons.person),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context)=> const ProfilePage()
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
      body: TabBarView(
        controller: _tabController,
          children: [
            Text("Discover"),
            QuestTab()
          ]
      ),
      drawer: SettingsNavBar(),
    );
  }
}