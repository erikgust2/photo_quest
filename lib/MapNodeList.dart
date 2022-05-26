import 'MapNode.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapNodeList {

  bool hasFilled = false; //dirty solution but whatever

  static MapNodeList _instance = MapNodeList._internal();
  MapNodeList._internal(){
    _instance = this;
  }

  factory MapNodeList() => _instance;

  Set<MapNode> nodes = {};

  Future refreshFriends() async {
    Uri URIOne = Uri.parse(
        'https://storm-elderly-conchoraptor.glitch.me/friends');
    final resOne = await http.get(URIOne);
    var data = json.decode(resOne.body);
    if (!hasFilled) {
      for (int i = 0; i < 15; i++) {
        nodes.add(MapNode.fromJson(data[i]));
      }
      hasFilled = true;
    }
    print(nodes);
  }


  void remove(MapNode value){
    nodes.remove(value);
  }

  List<MapNode> getMapNodes() {
    refreshFriends();
    return nodes.toList();
  }
}