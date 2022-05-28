// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);


//List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

//String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapNode {
  MapNode({
    required this.name,
    required this.type,
    required this.coordinate,
    required this.description,
    required this.image,
    required this.id
  });

  String name;
  String type;
  String coordinate;
  String description;
  String image;
  String id;

  factory MapNode.fromJson(Map<String, dynamic> json) => MapNode(
    name: json["name"],
    type: json["type"],
    coordinate: json["coordinate"],
    description: json["description"],
    image: json["image"],
    id: json["id"]
  );

  LatLng getCoordinates() {
    List coords = [];
    coords = coordinate.split(", ");
    double latitude = double.parse(coords[0]);
    double longitude = double.parse(coords[1]);
    LatLng coordinates = LatLng(latitude, longitude);
    return coordinates;
  }

  String getImage(){
    if(image.isEmpty) return "assets/images/notfound.png";
    return image;
  }

  @override
  String toString() {
    return name + " " + type  + " " + description  + " " + coordinate;
  }

  @override
  bool operator ==(Object other) {
    if (other is MapNode){
      return identical(id, other.id);
    }
    return super == other;
  }

  @override
  int get hashCode => name.hashCode;

}


