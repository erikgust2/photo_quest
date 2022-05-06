
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_quest/searchItem.dart';
import 'package:photo_quest/searcher.dart';
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import 'xmlParser.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

void main() => runApp(MyApp());


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
  var typemap = MapType.normal;
  String south = "";
  String west = "";
  String east = "";
  String north = "";
  // The function that fetches data from the API
  Future<void> _fetchData(dynamic URL) async {//(boundingBox=/WGS84+ ”väst syd ost nord”)
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
    target: LatLng(59.329353, 18.068776), zoom: 15,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Quest Creator'),
      ),
      body: GoogleMap(initialCameraPosition: _initialCameraPosition,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: true,
        mapType: typemap,
        onMapCreated: (controller) {
          setState(() {
                controller = controller;
              });
            },
            onTap: (coordinate1) {
              setState(() {//”väst syd ost nord”)
                west = coordinate1.longitude.toString();
                south = coordinate1.latitude.toString();
                east = (coordinate1.longitude+0.02).toString();
                north = (coordinate1.latitude+0.02).toString();
                dynamic URL = searcher.search("", "", west + ", "+ south + ", " + east + ", " + north);
                _fetchData(URL);
                print(_loadedItems.toString());
              });
            },
            onLongPress: (coordinate2) {
              setState(() {

              });
            },
          ),
      );
  }
}
