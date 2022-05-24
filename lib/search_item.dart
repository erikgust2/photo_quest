import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchItem {
  String itemID = "";
  String itemTitle = "";
  String itemDescription = "";
  String itemType = "";
  String itemTimeLabel = "";
  String itemPlaceLabel = "";
  String itemCoordinates = "";

  void setID (String iD) {
    itemID = iD;
  }

  void setTitle (String title){
    itemTitle = title.toUpperCase();
  }

  void setDescription(String description) {
    if(!description.contains("För eventuell historik") && !description.contains("null")) {
      if (itemDescription.isNotEmpty) {
        itemDescription += " " + description.trim();
      }
      else {
        itemDescription = description.trim();
      }
    }
  }

  void setType(String type) {
    itemType = type.trim();
  }

  void setTimeLabel(String timeLabel) {
    itemTimeLabel = timeLabel.trim();
  }

  void setPlaceLabel(String placeLabel) {
    itemPlaceLabel = placeLabel.trim();
  }

  LatLng getCoordinates() {
    List coords = [];
    coords = itemCoordinates.split(",");
    double longitude = double.parse(coords[0]);
    double latitude = double.parse(coords[1]);
    LatLng coordinates = LatLng(latitude, longitude);
    return coordinates;
  }

  void setCoordinates(String coordinates) {
    itemCoordinates = coordinates;
  }


  @override
  String toString(){
    return "\ntitle: " + itemTitle.trim().replaceAll(',', '') + "\n description: " + itemDescription.trimLeft() +
        "\n place: " + itemPlaceLabel + "\n time: " + itemTimeLabel +
        "\n type: "+ itemType + "\n coordinates: "+ getCoordinates().toString() + "\n";
  }

}