import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:photo_quest/completed_quests.dart';
import 'quest.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';


class QuestNodeList {

  static QuestNodeList _instance = QuestNodeList._internal();
  QuestNodeList._internal(){
    _instance = this;
    getLocation();
  }

  factory QuestNodeList() => _instance;

  static Set<QuestNode> nodes = {};

  static Set<QuestNode> selectedNodes = {};

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
    return "distance: " + _distanceInMeters.toString().split(".").first + " m";
  }

  Future refreshFriends() async {
    getLocation();
    Uri URIOne = Uri.parse(
        'https://storm-elderly-conchoraptor.glitch.me/friends');
    final resOne = await http.get(URIOne);
    var data = json.decode(resOne.body);
      for (int i = 0; i < 15; i++) {
        QuestNode node = QuestNode.fromJson(data[i]);
        if (!checkCreated(node)) {
          nodes.add(node);
        }
      }

  }

  void select(QuestNode node){
    selectedNodes.add(node);
  }

  void selectAll(String searchType){
    selectedNodes.clear();
    selectedNodes.addAll(nodes.where((node) => node.type == searchType));
  }

  void deselect(QuestNode node){
    if (selectedNodes.length == 1) {
      selectedNodes.clear();
      nodes.clear();
      refreshFriends();
    }
    selectedNodes.remove(node);
  }

  bool checkSelected(QuestNode node){
    bool selected = false;
    selectedNodes.forEach((item) {if (item.id == node.id) selected = true;});
    return selected;
  }

  bool checkCreated(QuestNode node){
    bool created = false;
    nodes.forEach((item) {if (item.id == node.id) created = true;});
    return created;
  }

  void complete(QuestNode node){
    QuestCompleted.nodes.add(node);
    nodes.remove(node);
    selectedNodes.remove(node);
  }

  List<QuestNode> getQuestNodes() {
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