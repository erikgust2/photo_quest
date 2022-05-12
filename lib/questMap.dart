
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:photo_quest/questHandler.dart';
import 'package:photo_quest/searchItem.dart';
import 'package:photo_quest/searcher.dart';
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import 'xmlParser.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:geolocator/geolocator.dart';


void main() => runApp(const QuestMapPage());

class QuestMapPage extends StatelessWidget {
  const QuestMapPage({Key? key}) : super(key: key);

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

  static const _initialCameraPosition = CameraPosition(//this position is Central Stockholm
    target: LatLng(59.329353, 18.068776), zoom: 12,);

  GoogleMapController? mapController; //controller for Google map

  Set<Marker> _markers = {}; //markers of search items for google map

  Set<SearchItem> _loadedItems = {};//searchItems loaded after fetching data and parsing the XML

  var mapType = MapType.normal;

  late LatLng currentCoordinates;

  late SearchItem _selectedItem;// when a marker is clicked on, it becomes the selected item

  late QuestHandler handler;

  Future<void> _createMarkers() async {
    BitmapDescriptor searchIcon = BitmapDescriptor.defaultMarker;
    setState(() {_markers.addAll(
    _loadedItems.map((item) =>
        Marker(
            icon: searchIcon,//add first marker
            markerId: MarkerId(item.itemTitle + item.getCoordinates().toString()),
            position: item.getCoordinates(), //position of marker
            infoWindow: InfoWindow( //popup info
                title: item.itemTitle,
                onTap: () {
                  _selectedItem = item;
                  _showMyDialog();
                }
            )
        )));
    });
        }


  Future<void> _showMyDialog() async {  //text box thing that pops up when a marker is clicked on
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_selectedItem.itemTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(_selectedItem.itemTitle),
                if(_selectedItem.itemDescription.isNotEmpty && _selectedItem.itemDescription != "null" && !_selectedItem.itemDescription.contains("För eventuell historik se under Dokument"))
                  Text(_selectedItem.itemDescription), //needs to be in separate dropdownbutton, descriptions are sometimes very long
                Text(_selectedItem.itemPlaceLabel),
                Text(_selectedItem.itemTimeLabel),
                Text(handler.getDistance(_selectedItem.getCoordinates(), currentCoordinates).toString().split(".").first + " m") /**SET UP SO DISTANCE IS SHOWN**/
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

  void getItems() async{ //gets the items from handler
    var location = await handler.getLocation();
    setState(() {
      handler.getSearchItems(LatLng(location.latitude, location.longitude));
      currentCoordinates = LatLng(location.latitude, location.longitude);
      _loadedItems = handler.loadedItems;
      _createMarkers();
    });
    handler.currentLocation.onLocationChanged.listen((LocationData loc){
      mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(loc.latitude ?? 0.0,loc.longitude?? 0.0),
        zoom: 12.0,
      )));
      setState(() {
            handler.getSearchItems(LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0));
            currentCoordinates = LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0);
            _loadedItems = handler.loadedItems;
            _createMarkers();
      });
    });
  }

  @override
  void initState(){
    super.initState();
    setState(() {
      handler = QuestHandler.DEFAULT_INSTANCE;
      getItems();
    });
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(initialCameraPosition: _initialCameraPosition,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        mapType: mapType,
        markers: _markers,
        onMapCreated: (controller) {
        setState(() {
                mapController = controller;
              });
            },
            onTap: (coordinate) {
              setState(() {
                handler.getSearchItems(coordinate);
                _loadedItems = handler.loadedItems;
                _createMarkers();
              });
            },
          ),
      );
  }
}