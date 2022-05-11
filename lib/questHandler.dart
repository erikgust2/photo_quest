
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

  Set<SearchItem> loadedItems = {};//searchItems loaded after fetching data and parsing the XML
  String searchType = ""; //( Föremål, Byggnad, Kulturlämning, Konstverk, Kulturmiljö, Objekt)
  String searchQuery = ""; //for example statues, churches, bones, some items have years associated
  String searchQuantity= "20"; //default size, can be modified for less items
  String south = "";  // URL uses (boundingBox=/WGS84+ ”väst syd ost nord”)
  String west = "";
  String east = "";
  String north = "";
  double searchSize = 0.005; //1 km
  Searcher searcher = Searcher.getInstance(); //singleton (I know singelton is generally supposed to be avoided
  // but this class gets the URL
  late LatLng currentCoordinates;
  Location currentLocation = Location();

  QuestHandler(String query, String type, String quantity){
    searchType = type; //( Föremål, Byggnad, Kulturlämning, Konstverk, Kulturmiljö, Objekt)
    searchQuery = query; //for example statues, churches, bones, some items have years associated
    searchQuantity = quantity;
  }

  void makeNewQuery(String query, String type, String quantity, LatLng coordinate){
    searchType = type; //( Föremål, Byggnad, Kulturlämning, Konstverk, Kulturmiljö, Objekt)
    searchQuery = query; //for example statues, churches, bones, some items have years associated
    searchQuantity = quantity;
    getSearchItems(coordinate);
  }

  // The function that fetches data from the API
  Future<void> _fetchData(dynamic URL) async {
    final response = await http.get(Uri.parse(URL));
    final document = XmlDocument.parse(response.body);
    XMLParser p = XMLParser();
    p.parse(document);
    loadedItems.addAll(p.getItems()); //parser puts everything in the set after parsing into search items
  }

  Future<void> getSearchItems(LatLng coordinate) async{
    west = coordinate.longitude.toString();
    south = coordinate.latitude.toString();
    east = (coordinate.longitude + searchSize).toString();
    north = (coordinate.latitude + searchSize).toString();  //makes a box for items
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



  Widget build(BuildContext context, SearchItem selectedItem) {
    return Scaffold(
      body: ListBody(
        children: <Widget>[
        Text(selectedItem.getType()),
        if(selectedItem.getDescription().isNotEmpty && selectedItem.getDescription() != "null" && !selectedItem.getDescription().contains("För eventuell historik se under Dokument"))
        Text(selectedItem.getDescription()), //needs to be in separate dropdownbutton, descriptions are sometimes very long
        Text(selectedItem.getPlaceLabel()),
        Text(selectedItem.getTimeLabel()),
        Text(getDistance(selectedItem.getCoordinates(), currentCoordinates).toString().split(".").first + " m") /**SET UP SO DISTANCE IS SHOWN**/
    ],
    ),
      );
  }
}
