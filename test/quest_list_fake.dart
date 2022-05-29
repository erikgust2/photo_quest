import 'package:flutter_test/flutter_test.dart';
import 'package:photo_quest/quest.dart';
import 'package:photo_quest/quest_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:photo_quest/completed_quests.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
class FakeQuestList extends Fake implements QuestNodeList {

  static FakeQuestList _instance = FakeQuestList._internal();
  FakeQuestList._internal(){
  _instance = this;
  }

  factory FakeQuestList() => _instance;

  static Set<QuestNode> availableQuests = {};

  static Set<QuestNode> selectedNodes = {};

  static Set<QuestNode> completedQuests = {};

  @override
  Location currentLocation = Location();


  @override
  Future<LatLng> getLocation() async {
  var location = await currentLocation.getLocation();
  var currentCoordinates = LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0);
  return currentCoordinates;
  }

  @override
  String getDistance (LatLng coord1, LatLng coord2) {
  var _distanceInMeters = Geolocator.distanceBetween(
  coord1.latitude,
  coord1.longitude,
  coord2.latitude,
  coord2.longitude
  );
  return "distance: " + _distanceInMeters.toString().split(".").first + " m";
  }

  @override
  void select(QuestNode node){
  selectedNodes.add(node);
  }

  @override
  void selectAll(String searchType){
  selectedNodes.clear();
  selectedNodes.addAll(availableQuests.where((node) => node.type == searchType));
  }

  @override
  void deselectAll(String searchType){
  selectedNodes.removeWhere((element) => element.type == searchType);
  }

  @override
  void deselect(QuestNode node){
  if (selectedNodes.length == 1) {
  selectedNodes.clear();
  availableQuests.clear();
  }
  selectedNodes.remove(node);
  }

  @override
  bool checkSelected(QuestNode node){
  bool selected = false;
  selectedNodes.forEach((item) {if (item.id == node.id) selected = true;});
  return selected;
  }

  @override
  bool checkCreated(QuestNode node){
  bool created = false;
  availableQuests.forEach((item) {if (item.id == node.id) created = true;});
  return created;
  }

  @override
  void complete(QuestNode node){
  completedQuests.add(node);
  availableQuests.remove(node);
  selectedNodes.remove(node);
  }

  @override
  List<QuestNode> getQuestNodes() {
  if (selectedNodes.isNotEmpty){
  return selectedNodes.toList();
  }
  return availableQuests.toList();
  }

  @override
  List<QuestNode> getCompletedQuests(){
  return completedQuests.toList();
  }

  @override
  dispose(){
  availableQuests.clear();
  selectedNodes.clear();
  }
  }

void main() {
  // Create a new fake Cat at runtime.
  var list = FakeQuestList();

  group('testing location', (){
    const coord1 = LatLng(0.0,0.0);
    const coord2 = LatLng(1.0,1.0);
    const coord3 = LatLng(-10000.0,-10000.0);
    const coord4 = LatLng(-1,-1);
    const coord5 = LatLng(1,1);
    test('testing distance', (){
      expect(list.getDistance(coord1, coord2), "distance: 157425 m");
    });

    test('testing opposite distance', (){
      expect(list.getDistance(coord2, coord1), "distance: 157425 m");
    });

    test('testing negative distance', (){
      expect(list.getDistance(coord2, coord3), "distance: 10130073 m");
    });

    test('testing integer distance', (){
      expect(list.getDistance(coord4, coord5), "distance: 314851 m");
    });

  });

  group('testing quest completion', (){

    var node1 = QuestNode(description: '1', type: '1', name: '1', coordinate: '1', id: '1', image: '1');
    var node2 = QuestNode(description: '2', type: '2', name: '2', coordinate: '2', id: '2', image: '2');
    var node3 = QuestNode(description: '3', type: '3', name: '3', coordinate: '3', id: '3', image: '3');
    var node4 = QuestNode(description: '4', type: '4', name: '4', coordinate: '4', id: '4', image: '4');
    var node5 = QuestNode(description: '5', type: '5', name: '5', coordinate: '5', id: '5', image: '5');

    FakeQuestList.availableQuests = {node1, node2, node3};

    test('check if created true', (){
      expect(list.checkCreated(node1), true);
    });

    test('check if selected true', (){
      list.select(node1);
      expect(list.checkSelected(node1), true);
    });

    test('check if created true after select and deselect', (){
      list.select(node1);
      list.deselect(node1);
      expect(list.checkSelected(node1), false);
    });

    test('check if created true after select and complete', (){
      list.select(node1);
      list.complete(node1);
      expect(list.checkCreated(node1), false);
    });

    test('check if created true after select and deselect', (){
      list.select(node1);
      list.complete(node1);
      expect(list.checkSelected(node1), false);
    });
  });

}