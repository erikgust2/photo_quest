import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_quest/quest_map.dart';
import 'quest_list.dart';
import 'quest.dart';




class QuestCompleted extends StatelessWidget{

  static List<QuestNode> nodes = QuestNodeList().getCompletedQuests().toList();

  bool checkCompleted(QuestNode node){
    bool created = false;
    nodes.forEach((item) {if (item.id == node.id) created = true;});
    return created;
  }

  void add(QuestNode node){
    nodes.add(node);
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: nodes.length,
        itemBuilder: (BuildContext context, int index) {
          Image image = Image.asset(nodes[index].getImage(), height: 70,
            width: 70,);
          return Card(
            child: Container(
              decoration: BoxDecoration(image: DecorationImage(image: image.image,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    title: Text(nodes[index].name,
                      style: TextStyle(fontSize: 25, color: Colors.white),
                      textAlign: TextAlign.center,),
                    subtitle: Text(nodes[index].description + "\n" + QuestNodeList().getDistance(QuestNodeList.currentCoordinates, nodes[index].getCoordinates()),
                      style: TextStyle(fontSize: 12, color: Colors.white),
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
                           // _showChoiceDialog(context, nodes[index].name);


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
                          child: const Text('SELECT QUEST',
                            style: TextStyle(fontSize: 15, color: Colors
                                .black),),
                          onPressed: () {
                            QuestNodeList().select(nodes[index]);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context)=> const QuestMapPage()
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
                    ],
                  ),
                ],
              ),
            ),
          );}
    );
  }

}