
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:photo_quest/questHandler.dart';
import 'package:photo_quest/searchItem.dart';
import 'dart:core';


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

  static const _mapType = MapType.normal;

  static const _initialCameraPosition = CameraPosition( //this position is Central Stockholm
    target: LatLng(59.329353, 18.068776), zoom: 12,);

  final Set<Marker> _markers = {}; //markers of search items for google map

  GoogleMapController? mapController; //controller for Google map

  late LatLng currentCoordinates;

  late SearchItem _selectedItem; // when a marker is clicked on, it becomes the selected item

  late QuestHandler handler;

  void _createQuestMarkers() { ///reset markers for specific quests
    _markers.clear();
    _addQuestMarkers();
    setState(() {
      _markers.forEach((marker) {marker.onTap})
    });
  }

  void _addQuestMarkers() { ///add markers without resetting
    BitmapDescriptor searchIcon = BitmapDescriptor.defaultMarker;
    setState(() {
      _markers.addAll(
          handler.loadedItems.map((item) =>
              Marker(
                  icon: searchIcon, //add first marker
                  markerId: MarkerId(
                      item.itemTitle + item.getCoordinates().toString()),
                  position: item.getCoordinates(), //position of marker
                  infoWindow: InfoWindow( //popup info
                      title: item.itemTitle,
                      onTap: () {
                        _selectedItem = item;
                        _showMyDialog();
                      }
                  )
              )
          )
      );
    });
  }


  Future<void> _showMyDialog() async { ///text box thing that pops up when a marker is clicked on
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
                if(_selectedItem.itemDescription.isNotEmpty &&
                    _selectedItem.itemDescription != "null" &&
                    !_selectedItem.itemDescription.contains(
                        "För eventuell historik se under Dokument"))
                  Text(_selectedItem.itemDescription),
                //needs to be in separate dropdownbutton, descriptions are sometimes very long
                Text(_selectedItem.itemPlaceLabel),
                Text(_selectedItem.itemTimeLabel),
                Text(handler
                    .getDistance(
                    _selectedItem.getCoordinates(), currentCoordinates)
                    .toString()
                    .split(".")
                    .first + " m")
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                child: const Text('Save quest?'), ///not implemented
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
                child: const Text('Cancel'), ///closes window
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

  void getLocationWithoutItems() async {///starts handler without loading markers
    var location = await handler.getLocation();
    setState(() {
      currentCoordinates = LatLng(location.latitude, location.longitude);
    });
  }

  void getItems() async {/// gets the items from handler and loads markers
    var location = await handler.getLocation();
    handler.getSearchItemsWithCoordinates(LatLng(location.latitude, location.longitude));
    setState(() {
      currentCoordinates = LatLng(location.latitude, location.longitude);
      _addQuestMarkers();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      handler = QuestHandler.DEFAULT_INSTANCE; /// only used for demo purposes
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
        mapType: _mapType,
        markers: _markers,
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
            handler.currentLocation.onLocationChanged.listen((LocationData loc) {
              setState(() {
                getItems();
              });
            });
          });
        },
        onTap: (coordinate) {
          handler.makeQuery("", "", "20");
          handler.getSearchItemsWithCoordinates(coordinate);
          setState(() {
            _addQuestMarkers();
          });
        },
      ),
    );
  }
}