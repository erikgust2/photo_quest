// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);


//List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

//String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_quest/MapNodeList.dart';

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

  LatLng getCoordinates() {
    List coords = [];
    coords = coordinate.split(", ");
    double latitude = double.parse(coords[0]);
    double longitude = double.parse(coords[1]);
    LatLng coordinates = LatLng(latitude, longitude);
    return coordinates;
  }


  @override
  String toString() {
    return name + " " + type  + " " + description  + " " + coordinate;
  }

  @override
  bool operator ==(Object other) {
    if (other is MapNode){
      return identical(name, other.name);
    }
    return super == other;
  }

  @override
  int get hashCode => name.hashCode;

}


