import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  static Set<QuestNode> availableQuests = {};

  static Set<QuestNode> selectedNodes = {};

  static Set<QuestNode> completedQuests = {};

  static dynamic currentCoordinates;

  Location currentLocation = Location();

  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference completedIDs = FirebaseFirestore.instance.collection('completedQuests');

  Future<List> getCompletedList() async {
    DocumentReference docRef = completedIDs.doc(user.uid);
    DocumentSnapshot snapshot = await docRef.get().catchError((onError) {
      throw onError;
    });
    List completed = snapshot.get('completed');
    return completed;
  }


  addCompletedList(QuestNode node) async {
    DocumentReference docRef = completedIDs.doc(user.uid);
    DocumentSnapshot snapshot = await docRef.get().catchError((onError) {
      throw onError;
    });
    List completed = snapshot.get('completed');
    completed.add(node.id);
    docRef.set({'completed': completed});
    availableQuests.remove(node);
    QuestCompleted.nodes.add(node);
  }

  clearCompletedList() async {
    DocumentReference docRef = completedIDs.doc(user.uid);
    docRef.set({'completed': []});
  }

  Future<LatLng> getLocation() async {
    var location = await currentLocation.getLocation().catchError((onError) {
      throw onError;
    });
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
    List list = await getCompletedList().catchError((onError) {
      throw onError;
    });
    getLocation();
    Uri URIOne = Uri.parse(
        'https://storm-elderly-conchoraptor.glitch.me/friends');
    final resOne = await http.get(URIOne).catchError((onError) {
      throw onError;
    });
    var data = json.decode(resOne.body);
      for (int i = 0; i < 15; i++) {
        QuestNode node = QuestNode.fromJson(data[i]);
        if (!checkCreated(node)) {
          if(!list.contains(node.id)) {
            availableQuests.add(node);
          } else {
            completedQuests.add(node);
          }
        }
      }
  }

  void select(QuestNode node){
    selectedNodes.add(node);
  }

  void selectAll(String searchType){
    selectedNodes.clear();
    selectedNodes.addAll(availableQuests.where((node) => node.type == searchType));
  }

  void deselectAll(String searchType){
    selectedNodes.removeWhere((element) => element.type == searchType);
  }

  void deselect(QuestNode node){
    if (selectedNodes.length == 1) {
      selectedNodes.clear();
      availableQuests.clear();
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
    availableQuests.forEach((item) {if (item.id == node.id) created = true;});
    return created;
  }

  void complete(QuestNode node){
    if (!QuestCompleted().checkCompleted(node)){
    QuestCompleted.nodes.add(node);}
    availableQuests.remove(node);
    selectedNodes.remove(node);
  }

  List<QuestNode> getQuestNodes() {
    refreshFriends();
    if (selectedNodes.isNotEmpty){
      return selectedNodes.toList();
    }
    return availableQuests.toList();
  }

  List<QuestNode> getCompletedQuests(){
    return completedQuests.toList();
  }

  dispose(){
    availableQuests.clear();
    selectedNodes.clear();
  }
}