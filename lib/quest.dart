import 'dart:core';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Quest {
  late String questTitle;
  late String questDescription;
  late String questType;
  late String questTimeLabel;
  late String questCoordinates;

  Quest (String title, String type, String description, String time, String coordinates, String distance) {
    questTitle = title;
    questDescription = description;
    questType = type;
    questTimeLabel = time;
    questCoordinates = coordinates;
  }

    /// Gets and sets the quests title. */
    String getTitle() {
      return questTitle;
    }

    void setTitle(title) {
      questTitle = title.trim();
    }

    /// Gets and sets the quests description. */
    String getDescription() {
      return questDescription;
    }

    void setDescription(description) {
      if (questDescription.isNotEmpty) {
        questDescription += " " + description.trim();
      }
      else {
        questDescription = description.trim();
      }
    }

    /// Gets and sets the quests type. */
    String getType() {
      return questType;
    }
    void setType(String type) {
      questType = type.trim();
    }

    /// Gets and sets the quests time label. */
    String getTimeLabel() {
      return questTimeLabel;
    }

    void setTimeLabel(String timeLabel) {
      questTimeLabel = timeLabel.trim();
    }


    /// Gets and sets the quests coordinates. */
    LatLng getCoordinates() {
      List coords = [];
      coords = questCoordinates.split(",");
      double longitude = double.parse(coords[0]);
      double latitude = double.parse(coords[1]);
      LatLng coordinates = LatLng(latitude, longitude);
      return coordinates;
    }

    void setCoordinates(String coordinates) {
      questCoordinates = coordinates;
    }


    @override
    String toString() {
      return "\ntitle: " + getTitle().trim().replaceAll(',', '') +
          "\n description: " + getDescription().trimLeft()
          + "\n time: " + getTimeLabel() +
          "\n type: " + getType() + "\n coordinates: " +
          getCoordinates().toString() + "\n";
    }
  }
