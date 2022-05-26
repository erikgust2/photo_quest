/*// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

//String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MapNode {
  MapNode({
    required this.name,
    required this.type,
    required this.coordinate,
    required this.description,
  });

  String name;
  String type;
  String coordinate;
  String description;

  factory MapNode.fromJson(Map<String, dynamic> json) => MapNode(
    name: json["name"],
    type: json["type"],
    coordinate: json["coordinate"],
    description: json["description"],
  );

 /* Widget buildNode(BuildContext context) {
    Card(child: ListTile(
        isThreeLine: true,
        title : Text(item.itemTitle + "\n" + item.itemPlaceLabel + "\n" + item.itemTimeLabel),
        subtitle: Text(getDistance(item.getCoordinates(), currentCoordinates)
            .toString()
            .split(".")
            .first + " m")
    )))
  } */
    /*return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(name),
              subtitle: Text(description),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: const Text('TAKE PHOTO'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('VIEW ON MAP'),
                  onPressed: () {/* ... */},

                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  } */

}
/*
enum Type { BYGGNAD, KYRKA, PARK }

final typeValues = EnumValues({
  "byggnad": Type.BYGGNAD,
  "kyrka": Type.KYRKA,
  "park": Type.PARK
});
*/

/*
class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
*/
class MapNodeController extends StatefulWidget {
  MapNodeController({
    Key? key,
  }) : super(key: key);

  @override
  State<MapNodeController> createState() => MapNodeState();
}


class MapNodeState extends State<MapNodeController> {
  var friend;

  @override
  void initState() {
    refreshFriends();
    super.initState();
  }

  Future refreshFriends() async {
    Uri URIOne = Uri.parse(
        'https://storm-elderly-conchoraptor.glitch.me/friends');
    final resOne = await http.get(URIOne);
    var data = json.decode(resOne.body);
    var _friendsTemp;
    _friendsTemp = MapNode.fromJson(data['sys']);

    setState(() {
      friend = _friendsTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  friend.buildNode(context);
  }
} */

