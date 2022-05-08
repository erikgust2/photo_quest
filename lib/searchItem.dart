import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchItem {
  String itemTitle = "";
  String itemDescription = "";
  String itemType = "";
  String itemTimeLabel = "";
  String itemPlaceLabel = "";
  String itemCoordinates = "";

  /** Gets and sets the items title. */
  String getTitle() {
    return itemTitle;
  }

  void setTitle(title) {
    itemTitle = title.trim();
  }

  /** Gets and sets the items description. */
  String getDescription() {
    return itemDescription;
  }

  void setDescription(description) {
    if (itemDescription.isNotEmpty) {
      itemDescription += " " + description.trim();
    }
    else {
      itemDescription = description.trim();
    }
  }

  /** Gets and sets the items type. */
  String getType() {
    return itemType;
  }
  void setType(String type) {
    itemType = type.trim();
  }

  /** Gets and sets the items time label. */
  String getTimeLabel() {
    return itemTimeLabel;
  }

  void setTimeLabel(String timeLabel) {
    itemTimeLabel = timeLabel.trim();
  }

  /** Gets and sets the items place label. */
  String getPlaceLabel() {
    return itemPlaceLabel;
  }

  void setPlaceLabel(String placeLabel) {
    itemPlaceLabel = placeLabel.trim();
  }

  /** Gets and sets the items coordinates. */
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


  String toString(){
    return "\ntitle: " + getTitle().trim().replaceAll(',', '') + "\n description: " + getDescription().trimLeft() +
        "\n place: " + getPlaceLabel() + "\n time: " + getTimeLabel() +
        "\n type: "+ getType() + "\n coordinates: "+ getCoordinates().toString() + "\n";
  }

}