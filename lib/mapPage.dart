import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  MapScreen createState() => MapScreen();
}

class MapScreen extends State<MapPage> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(59.334591, 18.063240), zoom: 11.5,);

  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: GoogleMap(initialCameraPosition: _initialCameraPosition,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: true,)

    );
  }

}

