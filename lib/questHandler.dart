
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:photo_quest/searchItem.dart';
import 'package:photo_quest/searcher.dart';
import 'package:xml/xml.dart';
import 'xmlParser.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:geolocator/geolocator.dart';

class QuestHandler {
  static const List<String> _SEARCH_TYPES = ["Föremål", "Byggnad", "Kulturlämning", "Konstverk", "Kulturmiljö", "Objekt"];
  static final QuestHandler DEFAULT_INSTANCE = QuestHandler();

  Set<SearchItem> loadedItems = {};///searchItems loaded after fetching data and parsing the XML
  String searchType = ""; //( Föremål, Byggnad, Kulturlämning, Konstverk, Kulturmiljö, Objekt)
  String searchQuery = ""; //for example statues, churches, bones, some items have years associated
  String searchQuantity= "20"; ///default size, can be modified for less items
  String south = "";  /// URL uses (boundingBox=/WGS84+ ”väst syd ost nord”)
  String west = "";
  String east = "";
  String north = "";
  double searchSize = 0.005; //1 km
  Searcher searcher = Searcher.getInstance(); //singleton, this class gets the URL

  Location currentLocation = Location();
  late LatLng currentCoordinates;

  late SearchItem currentQuest;

  Set<SearchItem> makeQueryGetItems(String query, String type, String quantity) { /// main function to initialize the location and get the items in one go
    makeQuery(query, type, quantity);
    getSearchItems();
    return Set.unmodifiable(loadedItems);
  }

  void makeNewQuery(String query, String type, String quantity) {
    loadedItems.clear();
    makeQuery(query, type, quantity);
  }

  void makeQuery(String query, String type, String quantity) {
    searchType = type; ///( föremål, byggnad, kulturlämning, konstverk, kulturmiljö, objekt)
    searchQuery = query; ///for example statues, churches, bones, some items have years associated
    searchQuantity = quantity;
  }



  void selectQuest(SearchItem item){ /// NEEDS BACKEND OF COMPLETED QUESTS FOR THE CURRENT USER
    loadedItems.clear();
    loadedItems.add(item);
  }

  void selectQuests(List<SearchItem> items){ /// NEEDS BACKEND OF COMPLETED QUESTS FOR THE CURRENT USER
    loadedItems.clear();
    loadedItems.addAll(items);
  }

  /// The function that fetches data from the API
  Future<void> _fetchData(dynamic URL) async {
    final response = await http.get(Uri.parse(URL));
    final document = XmlDocument.parse(response.body);
    XMLParser p = XMLParser();
    p.parse(document);
    loadedItems.addAll(p.getItems()); ///parser puts everything in the set after parsing into search items
  }

  Future<void> getSearchItemsWithCoordinates(LatLng coordinate) async{
    west = coordinate.longitude.toString();
    south = coordinate.latitude.toString();
    east = (coordinate.longitude + searchSize).toString();
    north = (coordinate.latitude + searchSize).toString();  ///makes a box for items
    String URL = searcher.search(searchQuery, searchType, searchQuantity, west + "%20"+ south + "%20" + east + "%20" + north);
    _fetchData(URL);
  }

  Future<void> getSearchItems() async{
    getLocation();
    west = currentCoordinates.longitude.toString();
    south = currentCoordinates.latitude.toString();
    east = (currentCoordinates.longitude + searchSize).toString();
    north = (currentCoordinates.latitude + searchSize).toString();  ///makes a box for items
    String URL = searcher.search(searchQuery, searchType, searchQuantity, west + "%20"+ south + "%20" + east + "%20" + north);
    _fetchData(URL);
  }

  Future<LatLng> getLocation() async {
    var location = await currentLocation.getLocation();
    currentCoordinates = LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0);
    return currentCoordinates;
  }

  double getDistance (LatLng coord1, LatLng coord2) {
    var _distanceInMeters = Geolocator.distanceBetween(
        coord1.latitude,
        coord1.longitude,
        coord2.latitude,
        coord2.longitude
    );
    return _distanceInMeters;
  }

  Widget build(BuildContext context, SearchItem selectedItem) { /// LITERALLY JUST A USELESS WIDGET
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue[900],
            title: TextFormField(
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter query?',
                  labelStyle: TextStyle(color: Colors.white)
              ),
              onFieldSubmitted: (String search) {
                searchQuery = search;   //uses an empty string if nothing is written as the query, type is still undefined
              },
            ),
            actions:[             //attempt at creating a selection box for types, currently non-functional
              DropdownButton<String>(
                value: "type",
                icon: const Icon(Icons.search),
                elevation: 16,
                style: const TextStyle(color: Colors.white),
                items: _SEARCH_TYPES.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (item) {
                    searchType = item!;
                },
              )
            ]
        ),
      body: ListBody(
        children: <Widget>[
          Text(selectedItem.itemTitle),
          if(selectedItem.itemDescription.isNotEmpty && selectedItem.itemDescription != "null" && !selectedItem.itemDescription.contains("För eventuell historik se under Dokument"))
            Text(selectedItem.itemDescription), //needs to be in separate dropdownbutton, descriptions are sometimes very long
          Text(selectedItem.itemPlaceLabel),
          Text(selectedItem.itemTimeLabel),
        Text(getDistance(selectedItem.getCoordinates(), currentCoordinates).toString().split(".").first + " m") /**SET UP SO DISTANCE IS SHOWN**/
    ],
    ),
      );
  }
}
