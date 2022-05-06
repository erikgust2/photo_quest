
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_quest/searchItem.dart';
import 'package:photo_quest/searcher.dart';
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import 'xmlParser.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'searchPage',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // The list that contains challenge items
  List<SearchItem> _loadedItems = [];
  Searcher searcher = Searcher.getInstance();
  var options = [
    MapType.normal,
    MapType.hybrid,
    MapType.terrain,
    MapType.satellite,
  ];
  var _currentItemSelected = MapType.normal;
  var typemap = MapType.normal;
  String south = "";
  String west = "";
  String east = "";
  String north = "";
  // The function that fetches data from the API
  Future<void> _fetchData() async {//(boundingBox=/WGS84+ ”väst syd ost nord”)
    var URL = searcher.search("", "", "12.883397, 55.56512, 13.01874, 55.635582");
    //const API_URL = 'https://kulturarvsdata.se/ksamsok/api?method=search&version=1.1&hitsPerPage=25&query=boundingBox=/WGS84%20%2212.883397%2055.56512%2013.01874%2055.635582%22';
    final response = await http.get(Uri.parse(URL));
    final document = XmlDocument.parse(response.body);
    XMLParser p = XMLParser();
    p.parse(document);
    setState(() {
      _loadedItems = p.getItems().toList();
    });
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(55.56512, 12.883397), zoom: 15,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Quest Creator'),
        actions: [
          DropdownButton<MapType>(
            dropdownColor: Colors.blue[900],
            isDense: true,
            isExpanded: false,
            iconEnabledColor: Colors.white,
            focusColor: Colors.white,
            items: options.map((MapType dropDownStringItem) {
              return DropdownMenuItem<MapType>(
                value: dropDownStringItem,
                child: Text(
                  dropDownStringItem.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              );
            }).toList(),
            onChanged: (newValueSelected) {
              setState(() {
                _currentItemSelected = newValueSelected!;
                typemap = newValueSelected;
              });
            },
            value: _currentItemSelected,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            mapType: typemap,
            onMapCreated: (controller) {
              setState(() {
                controller = controller;
              });
            },
            onTap: (coordinate1) {
              setState(() {
                west = coordinate1.longitude.toString();
                south = coordinate1.latitude.toString();
              });
            },
            onLongPress: (coordinate2) {
              setState(() {
                east = coordinate2.longitude.toString();
                north = coordinate2.latitude.toString();
              });
            },
          ),
          Positioned(
            left: 5,
            bottom: 150,
            child: TextField(),
          ),
          Positioned(
            left: 15,
            bottom: 100,
            child: Text(
              south,
              softWrap: false,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
