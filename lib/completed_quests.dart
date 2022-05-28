import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'quest.dart';




class QuestCompleted extends StatelessWidget{

  static List<QuestNode> nodes = [];

  const QuestCompleted({Key? key}) : super(key: key);
  bool checkCompleted(QuestNode node){
    bool created = false;
    nodes.forEach((item) {if (item.id == node.id) created = true;});
    return created;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: nodes.map((item) =>
            Card(
              child: Container(
                /*decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("https://lh5.googleusercontent.com/p/AF1QipPldMa-x_UbdPtpn8xWH9V_7cVvogX2YqKMxZ0Z=w408-h544-k-no"),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),*/
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: Text(item.name,
                        style: TextStyle(fontSize: 25, color: Colors.black),
                        textAlign: TextAlign.center,),
                      subtitle: Text(item.description,
                        style: TextStyle(fontSize: 12, color: Colors.black),
                        textAlign: TextAlign.center,),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            child: const Text('TAKE PHOTO',
                              style: TextStyle(fontSize: 15, color: Colors
                                  .black),),
                            onPressed: () {
                            },
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(12.0),
                                primary: Colors.black,
                                textStyle: const TextStyle(fontSize: 15),
                                backgroundColor: Colors.blueAccent
                            )
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                            child: const Text('VIEW ON MAP',
                              style: TextStyle(fontSize: 15, color: Colors
                                  .black),),
                            onPressed: () {
                              /* ... */
                            },
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(12.0),
                                primary: Colors.black,
                                textStyle: const TextStyle(fontSize: 15),
                                backgroundColor: Colors.green
                            )
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            )
        ).toList()
    ));
  }

}