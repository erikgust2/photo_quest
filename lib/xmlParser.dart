
import 'dart:html';

import 'package:photo_quest/searchItem.dart';
import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';


class XMLParser {
  static const String TOTAL = "totalHits";
  static const String RECORDS = "records";
  static const String RECORD = "record";
  static const String TITLE = "itemLabel";
  static const String DESCRIPTION = "desc";
  static const String TYPE = "type";
  static const String DATE = "timeLabel";
  static const String PLACE = "placeLabel";
  static const String LINK = "url";
  static const String COORDINATES = "coordinates";
  Set<SearchItem> items = <SearchItem>{};

  void parse(XmlDocument doc) {
    Iterable<XmlNode> input = doc.nodes;
        if (input.isNotEmpty) {
          final description = doc.findAllElements(RECORD);
          for (var element in description) {
                    SearchItem item = SearchItem();
                    element.findAllElements('pres:type').forEach((type) {item.setType(type.text);});
                    element.findAllElements('pres:itemLabel').forEach((type) {item.setTitle(type.text);});
                    element.findAllElements('pres:description').forEach((type) {item.setDescription(type.text);});
                    element.findAllElements('pres:placeLabel').forEach((type) {item.setPlaceLabel(type.text);});
                    element.findAllElements('pres:timeLabel').forEach((type) {item.setTimeLabel(type.text);});
                    element.findAllElements('gml:coordinates').forEach((type) {item.setCoordinates(type.text);});
                    items.add(item);
                 }
          }
          for (var element in items) {print(element);}
      }
  Set<SearchItem> getItems(){
    return items;
  }
  }

