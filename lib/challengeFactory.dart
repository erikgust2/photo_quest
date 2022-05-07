
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_quest/mainSearch.dart';
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
  late GoogleMapController mapController; //contrller for Google map
  final Set<Marker> markers = new Set(); //markers for google map

  String south = "";
  String west = "";
  String east = "";
  String north = "";
  String searchType = "";
  String searchQuery = "";
  String type = "Select Search Type";

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
    target: LatLng(59.329353, 18.068776), zoom: 12,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Enter query',
        ),
        onFieldSubmitted: (String search) {
          searchQuery = search;
        }
        )
      ),/*
        DropdownButton<String>(
        value: type,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (newValue) {
          setState(() {
            searchQuery = newValue!;
          });
        },
        items: <String>["Föremål", "Byggnad","Kulturlämning", "Konstverk", "Kulturmiljö", "Objekt"]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      )*/

      body: GoogleMap(initialCameraPosition: _initialCameraPosition,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: true,
        mapType: typemap,
        markers:markers,
        onMapCreated: (controller) {
          setState(() {
                mapController = controller;
              });
            },
            onTap: (coordinate1) {
              setState(() {//”väst syd ost nord”)
                west = coordinate1.longitude.toString();
                south = coordinate1.latitude.toString();
                east = (coordinate1.longitude+0.02).toString();
                north = (coordinate1.latitude+0.02).toString();
                dynamic URL = searcher.search(searchQuery, searchType, west + "%20"+ south + "%20" + east + "%20" + north);
                _fetchData(URL);
                for (SearchItem item in _loadedItems) {
                  markers.add(Marker( //add first marker
                    markerId: MarkerId(item.getTitle()),
                    position: item.getCoordinates(), //position of marker
                    infoWindow: InfoWindow( //popup info
                      title: item.getTitle(),
                      snippet: item.getDescription(),
                    ),
                    icon: BitmapDescriptor.defaultMarker, //Icon for Marker
                  ));
                  print(item.toString() + "\n");
                }

              });
            },
          ),
      );
  }
}
