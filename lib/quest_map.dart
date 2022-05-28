
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_quest/profile.dart';
import 'dart:core';
import 'quest.dart';
import 'quest_list.dart';
import 'settings_drawer.dart';
import 'generated/l10n.dart';



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

  List<QuestNode> _loadedNodes = [];

  GoogleMapController? mapController; //controller for Google map


  @override
  void initState(){
    super.initState();
    setState(() {
      _loadedNodes = QuestNodeList().getQuestNodes();
      _createMarkers();
    });
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  BitmapDescriptor _getMarker(QuestNode node){
    if(QuestNodeList().checkSelected(node)) return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    return BitmapDescriptor.defaultMarker;
  }
  
  void _createMarkers() async{
    Set<Marker> markers = _markers.toSet();
    markers.addAll(
        _loadedNodes.skip(_markers.length).map((node) =>
            Marker(
                icon: _getMarker(node),//add first marker
                markerId: MarkerId(node.name+node.type),
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
    ],
    ),
            actions: [
              Builder(builder: (context) => IconButton(
                icon: Icon(Icons.person),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context)=> ProfilePage()
                  )
                  );
                },
              )

              )
            ],
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            )
        ),
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

  Widget acceptButton(BuildContext context, QuestNode node) {
    if (!QuestNodeList().checkSelected(node)){
      String message = 'Accept quest?';
      return ElevatedButton(
          child: Text(message),
          onPressed: () {
            QuestNodeList().select(node);
            Navigator.of(context).pop();
            _showFeedback("Quest Accepted!");
          },
          style: TextButton.styleFrom(
              padding: const EdgeInsets.all(12.0),
              primary: Colors.black,
              textStyle: const TextStyle(fontSize: 15),
              backgroundColor: Colors.green
          )
      );
    }
    String message = 'Cancel quest?';
    return ElevatedButton(
        child: Text(message),
        onPressed: () {
          QuestNodeList().deselect(node);
          Navigator.of(context).pop();
          _showFeedback("Quest Cancelled.");
        },
        style: TextButton.styleFrom(
            padding: const EdgeInsets.all(12.0),
            primary: Colors.black,
            textStyle: const TextStyle(fontSize: 15),
            backgroundColor: Colors.green
        )
    );
  }

  void _showFeedback(String message) async{
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: <Widget>[
              ElevatedButton(
                  child: const Text("OK"), ///closes window
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context)=> const NodeMapPage()
                    )
                    );
                  },
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(12.0),
                      primary: Colors.black,
                      textStyle: const TextStyle(fontSize: 15),
                      backgroundColor: Colors.green
                  )
              ),
            ],
          );
  });
  }

  void _showMyDialog(QuestNode node) async { ///text box thing that pops up when a marker is clicked on
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
                Text(QuestNodeList()
                    .getDistance(
                    node.getCoordinates(), QuestNodeList.currentCoordinates)
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
