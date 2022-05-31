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
    //Returns CircleAvatar with google profile photo
    return Padding(
        padding: const EdgeInsets.all(40.0),
        child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.bottomCenter,
            children:  [
              CircleAvatar(
                backgroundColor: Colors.pinkAccent,
                backgroundImage: NetworkImage(user.photoURL!),
                radius: 50,
              ),
            ]
        )
    );
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

  //List of user's Images
  List<Image> images = [];

  void _onClickedImage(Image image) {
    //Push a new page with the supplied image
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OpenPhotoRoute(image)),
    );
  }

  //does not work in current implementation because supplied image from parameter has no data that can be compared with the storage reference currently.
  //They both have hashCodes but aren't the same, so this function only removes the photo titled "Bostadshus.jpg" from the user's library of photos
  void _deletePhoto(Image image) async {
    final storageRef = FirebaseStorage.instance.ref().child('users/' + user.uid);
    final listResult = await storageRef.listAll();
    for(var item in listResult.items){

      //Hack to check that a photo can be deleted, "Bostadshus.jpg" should be replaced with whatever the image being looked at is called
      if (item.name == "Bostadshus.jpg"){
        final removeRef = storageRef.child("images/Bostadshus.jpg");
        await removeRef.delete();
      }
    }
    //This would then be called to remove the image from the user's image-list:
    //images.remove(image);

  }

  refreshImages() async{
    // images.clear();
    List<Image> imageList = [];
    final storageRef = FirebaseStorage.instance.ref().child('users/' + user.uid);
    final listResult = await storageRef.listAll();
    for(var item in listResult.items){
      final url = await item.getDownloadURL();
      imageList.add(Image.network(url));
    }
    setState(() {
    images = imageList;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshImages();
  }

  @override
  Widget build(BuildContext context) {
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
                GestureDetector(
                  onTap: () {
                    _onClickedImage(image);
          }, // Image tapped
                  child: Container(
                  alignment: Alignment.topCenter,
                  child: Text("image: " + index.toString()),
                  decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(image: image.image)),
                ),
                )]);
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
  bool showAppBar = false;
  late Image photo;

  _OpenPhotoRouteState(Image image){
    this.photo = image;
  }

  void _deletePic(Image image){
    _ProfilePageState()._deletePhoto(image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
        floatingActionButton: FloatingActionButton(mini: true, child: const Icon(Icons.arrow_back), backgroundColor: Colors.pinkAccent,
          onPressed: () {
            Navigator.of(context).pop();
            initState();
          },),
        appBar: showAppBar ? AppBar(
          backgroundColor: Colors.pink[100],
          title: const Text('Image'),
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