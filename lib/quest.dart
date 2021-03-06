// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);


//List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

//String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


import 'package:google_maps_flutter/google_maps_flutter.dart';


class QuestNode {
  QuestNode({
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
  bool accepted = false;

  factory QuestNode.fromJson(Map<String, dynamic> json) => QuestNode(
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
    double latitude = 0.0;
    double longitude = 0.0;
    try {
      latitude = double.parse(coords[0]);
      longitude = double.parse(coords[1]);
    }
    on FormatException catch (_){
      return LatLng(latitude, longitude);
    }
    LatLng coordinates = LatLng(latitude, longitude);
    return coordinates;
  }

  String getImage(){
    if(image.isEmpty || image.replaceAll(" ", "").isEmpty) return "assets/images/notfound.png";
    return image;
  }

  @override
  String toString() {
    return name + " " + type  + " " + description  + " " + coordinate;
  }

  @override
  bool operator ==(Object other) {
    if (other is QuestNode){
      return identical(id, other.id);
    }
    return super == other;
  }

  @override
  int get hashCode => name.hashCode;

  void decline(){
    accepted = false;
  }

  void accept(){
    accepted = true;
  }

}


