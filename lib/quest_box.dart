import 'package:flutter/material.dart';

import 'MapNodeList.dart';


class QuestBox extends StatelessWidget {
  QuestBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: MapNodeList().getMapNodes().map((item) =>
            Card(child: ListTile(
                isThreeLine: true,
                title: Text(
                    item.name + "\n" + item.type + "\n" + item.description),
                subtitle: Text(item.coordinate)
            ))).toList()
    );

    /*
    return Center(
      child: Card(
            child: Container(
            decoration: const BoxDecoration(
            image: DecorationImage(
            image: AssetImage("https://placeimg.com/640/480/any"),
        fit: BoxFit.fitWidth,
        alignment: Alignment.topCenter,
            ),
            ),
         child: Column (
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const ListTile(
                title: Text('EXAMPLE QUEST', style: TextStyle(fontSize: 25, color: Colors.black), textAlign: TextAlign.center,),
                subtitle: Text('Description of location...', style: TextStyle(fontSize: 12, color: Colors.black),textAlign: TextAlign.center,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: const Text('TAKE PHOTO', style: TextStyle(fontSize: 15, color: Colors.black),),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('VIEW ON MAP', style: TextStyle(fontSize: 15, color: Colors.black),),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }*/
  }
}

