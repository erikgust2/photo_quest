import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_quest/quest_list.dart';
import 'quest.dart';




class QuestCompleted extends StatelessWidget{

  static List<QuestNode> nodes = QuestNodeList().getCompletedQuests();

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
                decoration: BoxDecoration(image: DecorationImage(image: Image.asset(item.getImage()).image,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.center)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: Text(item.name,
                        style: TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold,shadows: [Shadow(blurRadius: 10)]),
                        textAlign: TextAlign.center,),
                      subtitle: Text(item.description,
                        style: TextStyle(fontSize: 15, color: Colors.white,shadows: [Shadow(blurRadius: 10)]),
                        textAlign: TextAlign.center,),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
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