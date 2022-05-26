
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:core';

import 'MapNode.dart';
import 'MapNodeList.dart';
import 'SettingsNavDrawer.dart';
import 'generated/l10n.dart';
import 'goldenHour.dart';



class NodeMapPage extends StatefulWidget {
  const NodeMapPage({Key? key}) : super(key: key);

  @override
  _NodeMapScreenState createState() =>  _NodeMapScreenState();
}

class _NodeMapScreenState extends State<NodeMapPage> {

  static const _mapType = MapType.normal;

  static const _initialCameraPosition = CameraPosition( //this position is Central Stockholm
    target: LatLng(59.329353, 18.068776), zoom: 12,);

  Set<Marker> _markers = {}; //markers of search items for google map

  Set<MapNode> _loadedNodes = {};

  GoogleMapController? mapController; //controller for Google map

  Location currentLocation = Location();

  @override
  void initState() {
    super.initState();
    getItems();
    }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }


  void getItems() async {
    //gets the items from handler
    if (mounted) {
      setState(() {
        _loadedNodes = MapNodeList().getMapNodes().toSet();
        _createMarkers();
      });
    }
  }

  void _createMarkers() async{
    BitmapDescriptor searchIcon = BitmapDescriptor.defaultMarker;
    Set<Marker> markers = _markers.toSet();
    markers.addAll(
        _loadedNodes.skip(_markers.length).map((node) =>
            Marker(
                icon: searchIcon,//add first marker
                markerId: MarkerId(node.name),
                position: node.getCoordinates(), //position of marker
                infoWindow: InfoWindow( //popup info
                    title: node.name,
                    onTap: () {
                      _showMyDialog(node);
                    }
                )
            )));
    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: Column(children: [
        Text(S.of(context).mapLabel,
    style: TextStyle(color: Colors.white, fontSize: 22.0),),
    //Text('Countdown',
    //style: TextStyle(color: Colors.white, fontSize: 12.0),),
    GoldenHourController(),
    ],
    )),
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
        ),
        drawer: const SettingsNavBar()
    );
  }

  Widget acceptButton(BuildContext context, MapNode node) {
    if (!MapNodeList().checkSelected(node)){
      return ElevatedButton(
          child: const Text('Accept quest?'), ///not implemented
          onPressed: () {
            MapNodeList().select(node);
            _createMarkers();
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
              padding: const EdgeInsets.all(12.0),
              primary: Colors.black,
              textStyle: const TextStyle(fontSize: 15),
              backgroundColor: Colors.green
          )
      );
    }
    return ElevatedButton(
        child: const Text('Cancel quest?'), ///not implemented
        onPressed: () {
          MapNodeList().deselect(node);
          _createMarkers();
          Navigator.of(context).pop();
        },
        style: TextButton.styleFrom(
            padding: const EdgeInsets.all(12.0),
            primary: Colors.black,
            textStyle: const TextStyle(fontSize: 15),
            backgroundColor: Colors.green
        )
    );
  }

  Future<void> _showMyDialog(MapNode node) async { ///text box thing that pops up when a marker is clicked on
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(node.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(node.name),
                Text(node.type),
                Text(MapNodeList()
                    .getDistance(
                    node.getCoordinates(), MapNodeList.currentCoordinates)
                    .toString()
                    .split(".")
                    .first + " m")
              ],
            ),
          ),
          actions: <Widget>[
            acceptButton(context, node),
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
                          title: Text(node.name),
                          content: SingleChildScrollView(
                              child: Text(node.description)
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
