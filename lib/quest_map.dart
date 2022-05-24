
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:photo_quest/quest_controller.dart';
import 'package:photo_quest/search_item.dart';
import 'dart:core';



class QuestMapPage extends StatelessWidget {
  const QuestMapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'searchPage',
      home: QuestMapScreen(),
    );
  }
}


class QuestMapScreen extends StatefulWidget {
  const QuestMapScreen({Key? key}) : super(key: key);

  @override
  _QuestMapScreenState createState() => _QuestMapScreenState();
}

class _QuestMapScreenState extends State<QuestMapScreen> {

  static const _mapType = MapType.normal;

  static const _initialCameraPosition = CameraPosition( //this position is Central Stockholm
    target: LatLng(59.329353, 18.068776), zoom: 12,);

  Set<Marker> _markers = {}; //markers of search items for google map

  Set<SearchItem> _loadedItems = {};

  GoogleMapController? mapController; //controller for Google map

  late LatLng currentCoordinates;

  late SearchItem _selectedItem; // when a marker is clicked on, it becomes the selected item

  late QuestController questController;


  @override
  void initState() {
    super.initState();
    setState(() {
      questController = QuestController.DEFAULT_INSTANCE;
      getItems();/// only used for demo purposes
    });
  }

  void _createMarkers() async{
    BitmapDescriptor searchIcon = BitmapDescriptor.defaultMarker;
    var markers = _markers;
    markers.addAll(
        _loadedItems.skip(_markers.length).map((item) =>
            Marker(
                icon: searchIcon,//add first marker
                markerId: MarkerId(item.itemID),
                position: item.getCoordinates(), //position of marker
                infoWindow: InfoWindow( //popup info
                    title: item.itemTitle,
                    onTap: () {
                      _selectedItem = item;
                      _showMyDialog();
                    }
                )
            )));
    setState(() {
      _markers = markers;
    });
  }

  void getItems() async{ //gets the items from handler
    var location = await questController.getLocation();
    setState(() {
      questController.getSearchItemsFromCoordinates(LatLng(location.latitude, location.longitude));
      currentCoordinates = LatLng(location.latitude, location.longitude);
      _loadedItems = questController.loadedItems;
      _createMarkers();
    });
    questController.currentLocation.onLocationChanged.listen((LocationData loc){
      setState(() {
        questController.getSearchItemsFromCoordinates(LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0));
        currentCoordinates = LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0);
        _loadedItems = questController.loadedItems;
        _createMarkers();
      });
    });
  }

  void getLocation() async {///starts handler without loading markers
    var location = await questController.getLocation();
    setState(() {
      currentCoordinates = LatLng(location.latitude, location.longitude);
    });
  }


  ///sets marker green and saves quest in controller
  void selectQuest(SearchItem item){
    questController.selectQuest(item);
    Marker greenMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), //add first marker
        markerId: MarkerId(item.itemID),
        position: item.getCoordinates(), //position of marker
        infoWindow: InfoWindow( //popup info
            title: item.itemTitle,
            onTap: () {
              _selectedItem = item;
              _showMyDialog();
            })
    );
    for (Marker marker in _markers){
      if (marker.markerId.value == item.itemID){
        setState(() {
          _markers.remove(marker);
          _markers.add(greenMarker);
        }
        );
        break;
      }
    }
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
          });
        },
        onTap: (coordinate) {
        questController.getSearchItemsFromCoordinates(coordinate);
        setState(() {
        _loadedItems = questController.loadedItems;
        _createMarkers();
        });},
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
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
                Text(_selectedItem.itemPlaceLabel),
                Text(_selectedItem.itemTimeLabel),
                Text(questController
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
                  selectQuest(_selectedItem);
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(12.0),
                    primary: Colors.black,
                    textStyle: const TextStyle(fontSize: 15),
                    backgroundColor: Colors.green
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
            ElevatedButton(
                child: const Text('Description'),
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(12.0),
                    primary: Colors.black,
                    textStyle: const TextStyle(fontSize: 15),
                    backgroundColor: Colors.blueAccent
                ),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(_selectedItem.itemTitle),
                          content: SingleChildScrollView(
                              child: Text(_selectedItem.itemDescription)
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                                child: const Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(12.0),
                                    primary: Colors.black,
                                    textStyle: const TextStyle(fontSize: 15),
                                    backgroundColor: Colors.blueAccent
                                )
                            )]
                      );
                    },

                  );}
            )
          ],
        );
      },
    );
  }
}