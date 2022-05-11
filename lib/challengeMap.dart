
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:photo_quest/searchItem.dart';
import 'package:photo_quest/searcher.dart';
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import 'xmlParser.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:geolocator/geolocator.dart';


void main() => runApp(const ChallengeMap());

class ChallengeMap extends StatelessWidget {
  const ChallengeMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'searchPage',
      home: ChallengeMapScreen(),
    );
  }
}



class ChallengeMapScreen extends StatefulWidget {
  const ChallengeMapScreen({Key? key}) : super(key: key);

  @override
  _ChallengeMapScreenState createState() => _ChallengeMapScreenState();
}

class _ChallengeMapScreenState extends State<ChallengeMapScreen> {

  final Set<Marker> markers = {}; //markers of search items for google map

  static const _initialCameraPosition = CameraPosition(//this position is Central Stockholm
    target: LatLng(59.329353, 18.068776), zoom: 12,);

  late GoogleMapController mapController; //controller for Google map

  var typemap = MapType.normal;

  Location currentLocation = Location();

  //final List<String> _searchTypes = ["foremal", "byggnad","kulturlämning", "konstverk", "kulturmiljo", "objekt", "type"];

  final Set<SearchItem> _loadedItems = {};//searchItems loaded after fetching data and parsing the XML

  Searcher searcher = Searcher.getInstance(); //singleton (I know singelton is generally supposed to be avoided
                                                // but this class gets the URL
  String south = "";  // URL uses (boundingBox=/WGS84+ ”väst syd ost nord”)
  String west = "";
  String east = "";
  String north = "";
  String searchType = ""; //( Föremål, Byggnad, Kulturlämning, Konstverk, Kulturmiljö, Objekt)
  String searchQuery = ""; //for example statues, churches, bones, some items have years associated
  String searchQuantity= "10"; //default size, can be modified for less items
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
            )
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
                if(_selectedItem.getDescription().isNotEmpty && _selectedItem.getDescription() != "null" && !_selectedItem.getDescription().contains("För eventuell historik se under Dokument"))
                  Text(_selectedItem.getDescription()), //needs to be in separate dropdownbutton, descriptions are sometimes very long
                Text(_selectedItem.getPlaceLabel()),
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


  Future<void> _getSearchItems(LatLng coordinate) async{
    west = coordinate.longitude.toString();
    south = coordinate.latitude.toString();
    east = (coordinate.longitude + searchSize).toString();
    north = (coordinate.latitude + searchSize).toString();  //makes a box for items
    String URL = searcher.search(searchQuery, searchType, searchQuantity, west + "%20"+ south + "%20" + east + "%20" + north);
    _fetchData(URL);
    _createMarkers();
  }

  void getLocation() async{
    var location = await currentLocation.getLocation();
    _getSearchItems(LatLng(location.latitude??0.0, location.longitude??0.0));
    currentLocation.onLocationChanged.listen((LocationData loc){
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(loc.latitude ?? 0.0,loc.longitude?? 0.0),
        zoom: 12.0,
      )));
      setState(() {
        markers.add(Marker(markerId: MarkerId('Home'),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));
            _getSearchItems(LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0));
      });
    });
  }

  @override
  void initState(){
    super.initState();
    setState(() {
      getLocation();
    });
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
        setState(() {
                mapController = controller;
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