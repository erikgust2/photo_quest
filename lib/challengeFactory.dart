
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
  final Set<Marker> markers = {}; //markers of search items for google map
  static const _initialCameraPosition = CameraPosition(//this position is Central Stockholm
    target: LatLng(59.329353, 18.068776), zoom: 12,);
  late GoogleMapController mapController; //controller for Google map
  var typemap = MapType.normal;

  Set<SearchItem> _loadedItems = {};//searchItems loaded after fetching data and parsing the XML
  Searcher searcher = Searcher.getInstance(); //singleton (I know singelton is generally supposed to be avoided
                                                // but this class gets the URL
  String south = "";  // URL uses (boundingBox=/WGS84+ ”väst syd ost nord”)
  String west = "";
  String east = "";
  String north = "";
  String searchType = ""; //(Föremål, Byggnad, Kulturlämning, Konstverk, Kulturmiljö, Objekt)
  String searchQuery = ""; //for example statues, churches, bones, some items have years associated
  String type = "Select Search Type";//text prompt in text field
  late SearchItem _selectedItem;// when a marker is clicked on, it mecomes the selected item

  // The function that fetches data from the API
  Future<void> _fetchData(dynamic URL) async {
    //example url: 'https://kulturarvsdata.se/ksamsok/api?method=search&version=1.1&hitsPerPage=25&query=boundingBox=/WGS84%20%2212.883397%2055.56512%2013.01874%2055.635582%22';
    final response = await http.get(Uri.parse(URL));
    final document = XmlDocument.parse(response.body);
    XMLParser p = XMLParser();
    p.parse(document);
    setState(() {
      _loadedItems.addAll(p.getItems()); //parser puts everything in the set after parsing into search items
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
          searchQuery = search;   //uses an empty string if nothing is written as the query, type is still undefined
        }
        ),
        /*actions:[             //attempt at creating a selection box for types, currently non-functional
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
          )
        ]*/
      ),
      body: GoogleMap(initialCameraPosition: _initialCameraPosition,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: true,
        mapType: typemap,
        markers: markers,
        onMapCreated: (controller) {
          setState(() {
                mapController = controller;
              });
            },
            onTap: (coordinate) {
              setState(() {//”väst syd ost nord”)
                west = coordinate.longitude.toString();
                south = coordinate.latitude.toString();
                east = (coordinate.longitude+0.02).toString();
                north = (coordinate.latitude+0.02).toString();
                dynamic URL = searcher.search(searchQuery, searchType, west + "%20"+ south + "%20" + east + "%20" + north);
                _fetchData(URL);
                _loadedItems.forEach((item) { //FOR SOME REASON IT ONLY LOADS THE MARKERS ON A SECOND CLICK, loads quest items
                  markers.add(Marker(
                    icon: BitmapDescriptor.defaultMarker,//add first marker
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
            },
          ),
      );
  }
}
