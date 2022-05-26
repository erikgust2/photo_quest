import 'MapNode.dart';

import 'MapNode.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapNodeList {

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
    if (nodes.isEmpty) {
      for (int i = 0; i < 15; i++) {
        nodes.add(MapNode.fromJson(data[i]));
      }
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