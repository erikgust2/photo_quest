import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchItem {
  String mTitle = "";
  String mDescription = "";
  String mType = "";
  String mTimeLabel = "";
  String mPlaceLabel = "";
  late LatLng mCoordinates;

  /** Gets and sets the items title. */
  String getTitle() {
    return mTitle;
  }

  void setTitle(title) {
    mTitle = title.trim();
  }

  /** Gets and sets the items description. */
  String getDescription() {
    return mDescription;
  }

  void setDescription(description) {
    if (mDescription != null) {
      mDescription += "\n\n" + description.trim();
    }
    else {
      mDescription = description.trim();
    }
  }

  /** Gets and sets the items type. */
  String getType() {
    return mType;
  }
  void setType(String type) {
    mType = type.trim();
  }

  /** Gets and sets the items time label. */
  String getTimeLabel() {
    return mTimeLabel;
  }

  void setTimeLabel(String timeLabel) {
    mTimeLabel = timeLabel.trim();
  }

  /** Gets and sets the items place label. */
  String getPlaceLabel() {
    return mPlaceLabel;
  }

  void setPlaceLabel(String placeLabel) {
    mPlaceLabel = placeLabel.trim();
  }

  /** Gets and sets the items coordinates. */
  LatLng getCoordinates() {
    return mCoordinates;
  }

  void setCoordinates(String coordinates) {
    List coords = [];
    coords = coordinates.split(",");

    double latitude = double.parse(coords[0]);
    double longitude = double.parse(coords[1]);
    mCoordinates = LatLng(latitude * 1e6, longitude * 1e6);
  }


  String toString(){
    return "title: " + getTitle().trim().replaceAll(',', '') + "\n description: " + getDescription() +
        "\n place: " + getPlaceLabel() + "\n time: " + getTimeLabel() +
        "\n type: "+ getType() + "\n coordinates: "+ getCoordinates().toString() + "\n";
  }

}