import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:photo_quest/QuestCompleted.dart';
import 'MapNode.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';


class MapNodeList {

  static MapNodeList _instance = MapNodeList._internal();
  MapNodeList._internal(){
    _instance = this;
    getLocation();
  }

  factory MapNodeList() => _instance;

  static Set<MapNode> nodes = {};

  static Set<MapNode> selectedNodes = {};

  static dynamic currentCoordinates;
  Location currentLocation = Location();

  Future<LatLng> getLocation() async {
    var location = await currentLocation.getLocation();
    currentCoordinates = LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0);
    return currentCoordinates;
  }

  String getDistance (LatLng coord1, LatLng coord2) {
    var _distanceInMeters = Geolocator.distanceBetween(
        coord1.latitude,
        coord1.longitude,
        coord2.latitude,
        coord2.longitude
    );
    return "distance: " + _distanceInMeters.toString() + " m";
  }

  Future refreshFriends() async {
    getLocation();
    Uri URIOne = Uri.parse(
        'https://storm-elderly-conchoraptor.glitch.me/friends');
    final resOne = await http.get(URIOne);
    var data = json.decode(resOne.body);
      for (int i = 0; i < 15; i++) {
        MapNode node = MapNode.fromJson(data[i]);
        if (!checkCreated(node)) {
          nodes.add(node);
        }
      }

  }

  void select(MapNode node){
    selectedNodes.add(node);
  }

  void selectAll(String searchType){
    selectedNodes.clear();
    selectedNodes.addAll(nodes.where((node) => node.type == searchType));
  }

  void deselect(MapNode node){
    if (selectedNodes.length == 1) {
      selectedNodes.clear();
      nodes.clear();
      refreshFriends();
    }
    selectedNodes.remove(node);
  }

  bool checkSelected(MapNode node){
    bool selected = false;
    selectedNodes.forEach((item) {if (item.name == node.name) selected = true;});
    return selected;
  }

  bool checkCreated(MapNode node){
    bool created = false;
    nodes.forEach((item) {if (item.name == node.name) created = true;});
    return created;
  }

  void complete(MapNode node){
    QuestCompleted.nodes.add(node);
    nodes.remove(node);
    selectedNodes.remove(node);
  }

  List<MapNode> getMapNodes() {
    refreshFriends();
    if (selectedNodes.isNotEmpty){
      return selectedNodes.toList();
    }
    return nodes.toList();
  }

  dispose(){
    nodes.clear();
    selectedNodes.clear();
  }
}