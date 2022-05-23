import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {



  profilePicture() {
    //Returns CircleAvatar with editable profile photo
    return Container(
      alignment: Alignment.topCenter,
      child: Stack(
          alignment: Alignment.center,
          children:  [
            CircleAvatar(
              backgroundColor: Colors.pinkAccent,

              //This should be the path to the user's image on their google account
              backgroundImage: NetworkImage('https://i.imgur.com/ZahwJjN.gif'),
              radius: 70,
            ),

            //An invisible clickable button the size of the avatar above that opens camera/gallery prompt
            GestureDetector(
                onTap: (){
                  //should communicate with camera.dart, not functional yet
                 // _showChoiceDialog(context);
                },
                child: const Positioned(
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 70,
                    ))
            ),
          ]
      ),
    );
  }

  profileInfo() {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.purple,
        ),
        child: const Text(
            'Username & Email here',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )
        )
    );
  }

  //Doesn't open a new page with the clicked image yet
  gallery() {
    //Returns a row on the bottom of the screen that is scrollable and contains the user's photos. When clicked they open
    //a new page with the clicked image

    return Container(
      alignment: Alignment.bottomCenter,
      height: 450,
      color: Colors.white,
      child:
      GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.start,

        //children should be the user's list of photos
        children: _getImages(tempList),
      ),
    );
  }

  //temporary list to test _getImages()
  List<Image> tempList = [
    Image.network('https://www.gravatar.com/avatar/12d378e6a9788ab9c94bbafe242b82b4?s=256&d=identicon&r=PG'),
    Image.network('https://www.gravatar.com/avatar/12d378e6a9788ab9c94bbafe242b82b4?s=256&d=identicon&r=PG'),
    Image.network('https://www.gravatar.com/avatar/12d378e6a9788ab9c94bbafe242b82b4?s=256&d=identicon&r=PG'),
    Image.network('https://www.gravatar.com/avatar/12d378e6a9788ab9c94bbafe242b82b4?s=256&d=identicon&r=PG'),
    Image.network('https://www.gravatar.com/avatar/12d378e6a9788ab9c94bbafe242b82b4?s=256&d=identicon&r=PG'),
    Image.network('https://www.gravatar.com/avatar/12d378e6a9788ab9c94bbafe242b82b4?s=256&d=identicon&r=PG'),
    Image.network('https://www.gravatar.com/avatar/12d378e6a9788ab9c94bbafe242b82b4?s=256&d=identicon&r=PG'),
    Image.network('https://www.gravatar.com/avatar/12d378e6a9788ab9c94bbafe242b82b4?s=256&d=identicon&r=PG'),
    Image.network('https://www.gravatar.com/avatar/b6fac6fc9baf619e8e52f77b44a2b6ca?s=256&d=identicon&r=PG'),
  ];

  List<Widget> _getImages(List<Image> userPhotos) {
    final List<Widget> images = <Widget>[];

    //loop through the user's photos and place them in the images list
    for (int i = 0; i < userPhotos.length; i++){
      images.add(GridTile(
          child: GestureDetector(
            onTap: () {
              _onClickedImage(userPhotos[i]);
            },
            child: Image(image: userPhotos[i].image, fit: BoxFit.cover,),
          )
      ),);
    }
    return images;
  }

  //should take an int i to be used in _getImages, to apply that image to the new page
  void _onClickedImage(Image image) {
    //Push a new page with the supplied image
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OpenPhotoRoute(image)),
    );
  }

  //does not work in current implementation because I'm not sending the correct image to this method
  void _deletePhoto(Image image){
    print(tempList.length);
    tempList.remove(image);
    print(tempList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: const Text("Profile"),
      ),

      //This column is for the profile photo and profile info
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            //This stack puts the profile picture and profile info on top of the backgroundImage.
            Stack(
                children: [
                  Image(
                    height: MediaQuery.of(context).size.height /3,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1585409677983-0f6c41ca9c3b?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max'
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        profilePicture(),
                        profileInfo(),
                      ]
                  )
                ]
            ),
            gallery(),
          ]
      ),
    );
  }
}

class OpenPhotoRoute extends StatefulWidget{
  late Image photo;

  OpenPhotoRoute(Image image){
    this.photo = image;
  }

  @override
  _OpenPhotoRouteState createState() => _OpenPhotoRouteState(photo);

}

//Page that displays the new image
class _OpenPhotoRouteState extends State<OpenPhotoRoute> {
  //const SecondRoute({key});
  bool showAppBar = false;
  late Image photo;

  _OpenPhotoRouteState(Image image){
    this.photo = image;
  }

  //Don't have a method called deletePic and another one called deletePhoto.
  //This is a temporary solution
  void _deletePic(Image image){
    _ProfilePageState()._deletePhoto(image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: showAppBar ? AppBar(
          backgroundColor: Colors.pink[100],
          title: const Text('Image name here'),
          actions: [
            PopupMenuButton(
                itemBuilder: (context){
                  return [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Delete Photo"),
                    ),
                  ];
                },
                onSelected:(value){
                  if (value == 0){
                    Navigator.pop(context);
                    _deletePic(photo);
                  }
                }),
          ],
        ) : null,
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: (){
            //show appBar here and hide it by default
            setState(() {
              showAppBar = !showAppBar;
            });
            print("hey");
          },
          child:
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: photo.image,
                )
            ),
            child:
            Image(image: photo.image),
          ),behavior: HitTestBehavior.translucent,
        )
    );
  }
}


//Need a user class but maybe there is one in the main branch already
/*
class User{
  final String name = //getgooglename
  List<Image> images;
  User(this.images);
}*/

