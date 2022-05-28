import 'package:flutter/material.dart';
import 'package:photo_quest/generated/l10n.dart';
import 'package:photo_quest/profile.dart';
import 'package:photo_quest/quest_map.dart';
import 'quest_list.dart';
import 'settings_drawer.dart';
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
              Text(S.of(context).collectionsLabel,
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
              Card(
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: Image.asset("assets/images/sofia.jpg").image,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                          title: Text("CHURCHES",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                            textAlign: TextAlign.center,)
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(width: 8),
                          ElevatedButton(
                              child: const Text('SELECT COLLECTION',
                                style: TextStyle(fontSize: 15, color: Colors
                                    .black),),
                              onPressed: () {
                                setState(() {
                                  MapNodeList().selectAll("kyrka");
                                });
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context)=> const NodeMapPage()
                                )
                                );
                              },
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(12.0),
                                  primary: Colors.black,
                                  textStyle: const TextStyle(fontSize: 15),
                                  backgroundColor: Colors.green
                              )
                          ),const SizedBox(width: 8),
                          ElevatedButton(
                              child: const Text('CANCEL',
                                style: TextStyle(fontSize: 15, color: Colors
                                    .black),),
                              onPressed: () {
                                MapNodeList().deselectAll("kyrka");
                              },
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(12.0),
                                  primary: Colors.black,
                                  textStyle: const TextStyle(fontSize: 15),
                                  backgroundColor: Colors.red
                              )
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: Image.asset("assets/images/humlan.jpg").image,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                          title: Text("PARKS",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                            textAlign: TextAlign.center,)
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(width: 8),
                          ElevatedButton(
                              child: const Text('SELECT COLLECTION',
                                style: TextStyle(fontSize: 15, color: Colors
                                    .black),),
                              onPressed: () {
                                setState(() {
                                  MapNodeList().selectAll("park");
                                });
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context)=> const NodeMapPage()
                                )
                                );
                              },
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(12.0),
                                  primary: Colors.black,
                                  textStyle: const TextStyle(fontSize: 15),
                                  backgroundColor: Colors.green
                              )
                          ),const SizedBox(width: 8),
                          ElevatedButton(
                              child: const Text('CANCEL',
                                style: TextStyle(fontSize: 15, color: Colors
                                    .black),),
                              onPressed: () {
                                MapNodeList().deselectAll("park");
                              },
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(12.0),
                                  primary: Colors.black,
                                  textStyle: const TextStyle(fontSize: 15),
                                  backgroundColor: Colors.red
                              )
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: Image.asset("assets/images/bostadshus.jpg").image,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                          title: Text("BUILDINGS",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                            textAlign: TextAlign.center,)
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(width: 8),
                          ElevatedButton(
                              child: const Text('SELECT COLLECTION',
                                style: TextStyle(fontSize: 15, color: Colors
                                    .black),),
                              onPressed: () {
                                setState(() {
                                  MapNodeList().selectAll("byggnad");
                                });
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context)=> const NodeMapPage()
                                )
                                );
                              },
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(12.0),
                                  primary: Colors.black,
                                  textStyle: const TextStyle(fontSize: 15),
                                  backgroundColor: Colors.green
                              )
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                              child: const Text('CANCEL',
                                style: TextStyle(fontSize: 15, color: Colors
                                    .black),),
                              onPressed: () {
                                MapNodeList().deselectAll("byggnad");
                              },
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(12.0),
                                  primary: Colors.black,
                                  textStyle: const TextStyle(fontSize: 15),
                                  backgroundColor: Colors.red
                              )
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]
        ));
  }
}