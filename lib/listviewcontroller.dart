import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart';

class FriendItem {
  final String type;
  List<dynamic> coordinates;

  FriendItem(this.type, this.coordinates);

  Widget buildTitle(BuildContext context) {
    return Text(type);
  }

  Widget returnCoordinates(BuildContext context) {
    return coordinates[0];
  }

  factory FriendItem.fromJson(Map<String, dynamic> json) {
    List<dynamic> tempPlace;

    tempPlace = json['coordinates'];
    /* if (json['referenceType'] == '2022-05-03T15:00:00Z') {
      tempPlace = Icon(Icons.home);
    } else if (json['location'] == 'work') {
      tempPlace = Icon(Icons.business_center);
    } else {
      tempPlace = Icon(Icons.visibility_off);
    } */
    return FriendItem(json['type'], tempPlace);
  }
}

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);
/*
import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    this.approvedTime,
    this.referenceTime,
  });

  DateTime approvedTime;
  DateTime referenceTime;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    approvedTime: DateTime.parse(json["approvedTime"]),
    referenceTime: DateTime.parse(json["referenceTime"]),
  );

  Map<String, dynamic> toJson() => {
    "approvedTime": approvedTime.toIso8601String(),
    "referenceTime": referenceTime.toIso8601String(),
  };
} */

class ListViewController extends StatefulWidget {
  ListViewController({
    Key? key,
  }) : super(key: key);

  @override
  State<ListViewController> createState() => _ListViewControllerState();
}

class _ListViewControllerState extends State<ListViewController> {
  var friends = [];

  @override
  void initState() {
    refreshFriends();
    super.initState();
  }

  Future refreshFriends() async {
   // Uri URIOne = Uri.parse('https://opendata.smhi.se/apidocs/metobs/res/data.json');
   // final resOne = await http.get(sampleFriendsURI);

   // Uri URITwo = Uri.https('opendata.smhi.se','/apidocs/metobs/res/data.json');
   // http.Response resTwo = await http.get(sampleFriendsURI);

    const url = "https://opendata.smhi.se/api/version/1.0/parameter/1/station/159880/period/latest-months/data.json";
    final resThree = await get(Uri.parse(url));


    var data = json.decode(resThree.body);
    friends = [];
    var _friendsTemp = [];

    for (var i = 0; i < data.length; i++) {
      _friendsTemp.add(FriendItem.fromJson(data));
    }
    setState(() {
      friends = _friendsTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: friends[index].buildTitle(context),
        );
      },
    ));
  }
}

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);
