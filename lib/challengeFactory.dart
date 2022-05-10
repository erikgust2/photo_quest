
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_quest/searchItem.dart';
import 'package:photo_quest/searcher.dart';
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import 'xmlParser.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:geolocator/geolocator.dart';

void main() => runApp(const ChallengeFactory());


class ChallengeFactory extends StatelessWidget {
  const ChallengeFactory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'searchPage',
      home: HomePage(),
    );
  }
}



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Set<Marker> markers = {}; //markers of search items for google map

  static const _initialCameraPosition = CameraPosition(//this position is Central Stockholm
    target: LatLng(59.329353, 18.068776), zoom: 12,);

  late GoogleMapController mapController; //controller for Google map

  var typemap = MapType.normal;

  final List<String> _searchTypes = ["foremal", "byggnad","kulturlämning", "konstverk", "kulturmiljo", "objekt", "type"];

  Set<SearchItem> _loadedItems = {};//searchItems loaded after fetching data and parsing the XML

  Searcher searcher = Searcher.getInstance(); //singleton (I know singelton is generally supposed to be avoided
                                                // but this class gets the URL
  String south = "";  // URL uses (boundingBox=/WGS84+ ”väst syd ost nord”)
  String west = "";
  String east = "";
  String north = "";
  String searchType = ""; //( Föremål, Byggnad, Kulturlämning, Konstverk, Kulturmiljö, Objekt)
  String searchQuery = ""; //for example statues, churches, bones, some items have years associated
  double searchSize = 0.005; //1 km

  late SearchItem _selectedItem;// when a marker is clicked on, it becomes the selected item



  // The function that fetches data from the API
  Future<void> _fetchData(dynamic URL) async {
    final response = await http.get(Uri.parse(URL));
    final document = XmlDocument.parse(response.body);
    XMLParser p = XMLParser();
    p.parse(document);
    setState(() {
      _loadedItems.addAll(p.getItems()); //parser puts everything in the set after parsing into search items
    });
  }



  Future<void> _createMarkers() async {
    BitmapDescriptor searchIcon = BitmapDescriptor.defaultMarker;
    _loadedItems.forEach((item) {
      setState(() {
      markers.add(Marker(
          icon: searchIcon,//add first marker
          markerId: MarkerId(item.toString()),
          position: item.getCoordinates(), //position of marker
          infoWindow: InfoWindow( //popup info
              title: item.getTitle(),
              onTap: () {
                _selectedItem = item;
                _showMyDialog();
              }
          ),
          visible: true //Icon for Marker
      )
      );
      });
    });
  }



  Future<void> _showMyDialog() async {  //text box thing that pops up when a marker is clicked on
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_selectedItem.getTitle()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(_selectedItem.getType()),
                if(_selectedItem.getDescription().isNotEmpty && _selectedItem.getDescription() != "null")
                  Text(_selectedItem.getDescription()), //needs to be in separate dropdownbutton, descriptions are sometimes very long
                Text(_selectedItem.getPlaceLabel().split(", ").last),
                Text(_selectedItem.getTimeLabel()),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Save quest?'),//not implemented
              onPressed: () {
                Navigator.of(context).pop();
              },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(12.0),
                  primary: Colors.black,
                  textStyle: const TextStyle(fontSize: 15),
                  backgroundColor: Colors.blueAccent
                )
            ),
            ElevatedButton(
              child: const Text('Cancel'),//closes window
              onPressed: () {
                Navigator.of(context).pop();
              },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(12.0),
                  primary: Colors.black,
                  textStyle: const TextStyle(fontSize: 15),
                  backgroundColor: Colors.redAccent
                )
            ),
          ],
        );
      },
    );
  }



  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }



  Future<void> _getSearchItems(LatLng coordinate) async{
    west = coordinate.longitude.toString();
    south = coordinate.latitude.toString();
    east = (coordinate.longitude + searchSize).toString();
    north = (coordinate.latitude + searchSize).toString();  //makes a box for items
    String URL = searcher.search(searchQuery, searchType, west + "%20"+ south + "%20" + east + "%20" + north);
    _fetchData(URL);
    _createMarkers();
  }


    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(initialCameraPosition: _initialCameraPosition,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        mapType: typemap,
        markers: markers,
        onMapCreated: (controller) {
        setState(() async {
                mapController = controller;
                _determinePosition();
                Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                double lat = position.latitude;
                double long = position.longitude;
                _getSearchItems(LatLng(lat, long));
              });
            },
            onTap: (coordinate) {
              setState(() {
                _getSearchItems(coordinate);
              });
            },
          ),
      );
  }
}
/*            ***THIS IS FOR MAKING A SEPARATE PAGE THAT ALLOWS USERS TO MAKE CHALLENGES DON'T DELETE***
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
            items: _searchTypes.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (item) {
              setState(() {
                searchType = item!;
              });
            },

          )
        ]
      ),*/