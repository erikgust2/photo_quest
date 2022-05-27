//import 'dart:html';

import 'dart:io';

//import 'package:camera/camera.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


class QuestBox extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();

  QuestBox({Key? key}) : super(key: key);

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Make a choice!"),
        content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text("Gallery"),
                  onTap: (){
                    _openGallery(context);
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0),),
                GestureDetector(
                  child: const Text("Camera"),
                  onTap: (){
                    _openCamera(context);
                  },
                )
              ],
            )
        ),
      );
    });
  }

  ImagePicker imagePicker = ImagePicker();
  var imageFile;

  _openGallery(BuildContext context) async {
    XFile? picture = await imagePicker.pickImage(source: ImageSource.gallery);
    //setState((){
    imageFile = picture as XFile;
    //});
    Navigator.of(context).pop();
    _uploadPhoto(imageFile);
  }

  _openCamera(BuildContext context) async {
    XFile? picture = await imagePicker.pickImage(source: ImageSource.camera);

    //setState((){
    imageFile = picture as XFile;
    //});
    Navigator.of(context).pop();
    _uploadPhoto(imageFile);
    //return imageFile;
  }

  /*Widget _decideImageView(){
    if(imageFile == null) {
      return const Text("No Selected Image!");
    } else {
      return Container(     //return Image.file(File(imageFile.path, ),width: 400, height: 400);
          child:
              CircleAvatar(
                backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/en/e/e9/Ratchet_and_Clank.png'),
              ));

    }
  }*/

  void _uploadPhoto(XFile image) async {
    //Takes an image and uploads it to FirebaseAuth.instance.currentUser's image-storage

    //reference to image.jpg
    final imageRef = storageRef.child("image.jpg");

    //reference to users/uid/image.jpg
    //"image.jpg" should be "the name of the quest".jpg
    final usersImageRef = storageRef.child("users/" + user.uid + "/image.jpg");

    //Directory appDocDir = await getApplicationDocumentsDirectory();
    //String filePath = '${appDocDir.absolute}/file-to-upload.png';
    //File file = File(filePath);

    File tempFile = File(image.path);

    try {
      //await imageRef.putFile(file);
      usersImageRef.putFile(tempFile);
    } on FirebaseException catch (e) {
      // Error uploading file,
      print("error uploading the image to FireBase");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('EXAMPLE QUEST'),
              subtitle: Text('Description of location...'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: const Text('TAKE PHOTO'),
                  onPressed: () {
                    _showChoiceDialog(context);
                    },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('VIEW ON MAP'),
                  onPressed: () {/*...*/},

                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

