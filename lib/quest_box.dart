import 'package:flutter/material.dart';
import 'package:photo_quest/QuestCompleted.dart';
import 'MapNode.dart';
import 'MapNodesMap.dart';
import 'MapNodeList.dart';



class QuestBox extends StatefulWidget{
  const QuestBox({Key? key}) : super(key: key);
  State<QuestBox> createState() => QuestBoxState();

}
class QuestBoxState extends State<QuestBox> {

  List<MapNode> nodes = [];
  @override
  void initState(){
    super.initState();
    setState(() {
      nodes = MapNodeList().getMapNodes();
    });
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: nodes.length,
        itemBuilder: (BuildContext context, int index) {

            return Card(
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
                      title: Text(nodes[index].name,
                        style: TextStyle(fontSize: 25, color: Colors.black),
                        textAlign: TextAlign.center,),
                      subtitle: Text(nodes[index].description + "\n" + MapNodeList().getDistance(MapNodeList.currentCoordinates, nodes[index].getCoordinates()),
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
                              setState(() {
                              MapNodeList().complete(nodes[index]);

                            },
                            );
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
                            MapNodeList().select(nodes[index]);
                            const NodeMapPage();
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

    /*Card(child: ListTile(
        isThreeLine: true,
        title: Text(
            item.name + "\n" + item.type + "\n" + item.description),
        subtitle: Text(item.coordinate)
    ))*/





