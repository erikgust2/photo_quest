
import 'package:photo_quest/searchItem.dart';
import 'package:xml/xml.dart';


class XMLParser {
  static const String RECORD = "record";
  static const String TITLE = "pres:itemLabel";
  static const String DESCRIPTION = "pres:description";
  static const String TYPE = "pres:type";
  static const String DATE = "pres:timeLabel";
  static const String PLACE = "pres:placeLabel";
  static const String COORDINATES = "gml:coordinates";
  Set<SearchItem> items = {};

  void parse(XmlDocument doc) {
    List<XmlNode> input = doc.children;
        if (input.isNotEmpty) {
          final records = doc.findAllElements(RECORD);
          for (var record in records) {
                    SearchItem item = SearchItem();
                    record.findAllElements(TYPE).forEach((type) {item.setType(type.text);});
                    record.findAllElements(TITLE).forEach((title) {item.setTitle(title.text);});
                    record.findAllElements(DESCRIPTION).forEach((desc){item.setDescription(desc.text.replaceAll("\n", " ").replaceAll("  ", " ").trim());});
                    record.findAllElements(PLACE).forEach((place) {item.setPlaceLabel(place.text.replaceAll("\n", " ").replaceAll("  ", "").trim());});
                    record.findAllElements(DATE).forEach((date) {item.setTimeLabel(date.text);});
                    record.findAllElements(COORDINATES).forEach((coord) {item.setCoordinates(coord.text.replaceAll(" ", "").replaceAll("\n", ""));});
                    if (item.itemCoordinates.isNotEmpty &&
                        item.itemTimeLabel.isNotEmpty)items.add(item);
                 }
        }
      }
  Set<SearchItem> getItems(){
    return items;
  }
  }
