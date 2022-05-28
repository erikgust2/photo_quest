import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photo_quest/settings_drawer.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'main.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final user = FirebaseAuth.instance.currentUser!;

  Widget buildProfilePicture() {
    //Returns CircleAvatar with editable profile photo
    return Padding(
        padding: const EdgeInsets.all(40.0),
        child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.bottomCenter,
            children:  [
              CircleAvatar(
                backgroundColor: Colors.pinkAccent,
                backgroundImage: //NetworkImage(user.photoURL!),
                NetworkImage('https://i.imgur.com/ZahwJjN.gif'),
                radius: 50,
              ),

              //An invisible clickable button the size of the avatar above that opens camera/gallery prompt
              GestureDetector(
                  onTap: (){
                    //should communicate with camera.dart, not functional yet
                    // _showChoiceDialog(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 40,
                  )),
            ]
        ));
  }

  Widget buildProfileInfo() {
    return  Text(
        'Username: ' + user.displayName! + "\n" + 'Email: ' + user.email.toString(),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        )
    );
  }

  //temporary list to test _getImages()
  List<Image> images = [
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
    print(images.length);
    images.remove(image);
    print(images.length);
  }

  refreshImages() async{
    // images.clear();

    final storageRef = FirebaseStorage.instance.ref().child('users/' + user.uid);
    final listResult = await storageRef.listAll();

    for(var item in listResult.items){
      final url = await item.getDownloadURL();
      images.add(Image.network(url));
    }
    print(images);
  }


  @override
  Widget build(BuildContext context) {
    refreshImages();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(220.0),
          child:  AppBar(
              title: Text("Profile"),
              backgroundColor: Colors.pink[244],
              flexibleSpace: buildProfilePicture(),
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(200.0),
                  child: buildProfileInfo()
              ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(mini: true, child: const Icon(Icons.arrow_back), backgroundColor: Colors.pinkAccent,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context)=> const MainScreen()));
        },),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: images.length,
        itemBuilder: (BuildContext ctx, index) {
          Image image = images[index];
          return Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: Text("image: " + index.toString()),
                  decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(image: image.image)),
                ),
              ]);
        }),
      drawer: SettingsNavBar(),
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

