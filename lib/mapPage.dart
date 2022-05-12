import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_quest/SettingsNavDrawer.dart';
import 'profilePage.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  MapScreen createState() => MapScreen();
}

class MapScreen extends State<MapPage> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(59.329353, 18.068776), zoom: 11.5,);

  @override
  Widget build(BuildContext context){
    return  Scaffold(
      appBar:   AppBar(
        backgroundColor: Colors.pink[200],
          actions: [
            Builder(builder: (context) => IconButton(
              icon: Icon(Icons.person),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> const ProfilePage()
                )
                );
              },
            )
            )
          ],
          title: Text('Map'),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          )
      ),
      drawer: const SettingsNavBar(),

      body: GoogleMap(initialCameraPosition: _initialCameraPosition,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: true,)


    );
  }

}

