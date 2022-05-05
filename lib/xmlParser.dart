
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
  Set<SearchItem> items = <SearchItem>{};

  void parse(XmlDocument doc) {
    Iterable<XmlNode> input = doc.nodes;
        if (input.isNotEmpty) {
          final records = doc.findAllElements(RECORD);
          for (var record in records) {
                    SearchItem item = SearchItem();
                    record.findAllElements(TYPE).forEach((type) {item.setType(type.text);});
                    record.findAllElements(TITLE).forEach((title) {item.setTitle(title.text);});
                    record.findAllElements(DESCRIPTION).forEach((desc) {item.setDescription(desc.text);});
                    record.findAllElements(PLACE).forEach((place) {item.setPlaceLabel(place.text);});
                    record.findAllElements(DATE).forEach((date) {item.setTimeLabel(date.text);});
                    record.findAllElements(COORDINATES).forEach((coord) {item.setCoordinates(coord.text);});
                    if (item.itemCoordinates.isNotEmpty)items.add(item);
                 }
        }
      }
  Set<SearchItem> getItems(){
    return items;
  }
  }

