import 'package:flutter/material.dart';
import 'package:photo_quest/generated/l10n.dart';
import 'package:photo_quest/profilePage.dart';
import 'MapNodeList.dart';
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
            centerTitle: true,
            title: Column(children: [
              Text(S.of(context).completedLabel,
                style: TextStyle(color: Colors.white, fontSize: 22.0),),
              //Text('Countdown',
              //style: TextStyle(color: Colors.white, fontSize: 12.0),),
            ],
            ),
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
      body: buildCollection(context),
      drawer: SettingsNavBar(),
    );
  }

  Widget buildCollection(BuildContext context) {
    return Scaffold(
        body: ListView(
            children:  <Widget> [
              Card(child: ListTile(
                  enabled: true,
                  title : Text("CHURCHES"),
                  trailing: const Icon(Icons.church),
                  onTap: () {MapNodeList().selectAll("kyrka");}
              )),
              Card(child: ListTile(
                  title : Text("PARKS"),
                  trailing: const Icon(Icons.wb_sunny_rounded),
                  onTap: () {MapNodeList().selectAll("park");}
              )),
              Card(child: ListTile(
                  title : Text("BUILDINGS"),
                  trailing: const Icon(Icons.home),
                  onTap: () {MapNodeList().selectAll("byggnad");}
              ))]
        ));
  }
}