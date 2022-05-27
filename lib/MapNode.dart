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

  String getImage(){
    String images = "assets/images/";
    switch (name)
    {
      case "Bostadshus":{return images + "bostadshus.jpg";}
    case "Slott":{return images + "slott.jpg";}
    case "Rikstadshuset":{return images + "riksdag.jpg";}
    case "Stuga":{return images + "stuga.jpg";}
    case "Solna kyrka":{return images + "solna.jpg";}
    case "Hagalunds kyrka":{return images + "hagalund.jpg";}
    case "Sofia kyrka":{return images + "sofia.jpg";}
    case "Riddarholms kyrkan":{return images + "riddar.jpg";}
    case "Ulriksdals slottskapell":{return images + "ulrik.jpg";}
    case "Some park":{return images + "some.jpg";}
    case "Hagaparken":{return images + "haga.jpg";}
    case "Humlegården":{return images + "humlan.jpg";}
    case "Vasa parken":{return images + "vasapark.jpg";}
    case "Vanadis parken":{return images + "vanadis.jpg";}
    }
    return images+"notfound.png";
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


