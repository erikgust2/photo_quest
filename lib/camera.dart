import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

/*
class Camera {

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
    setState((){
      imageFile = picture as XFile;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    XFile? picture = await imagePicker.pickImage(source: ImageSource.camera);
    setState((){
      imageFile = picture as XFile;
    });
    Navigator.of(context).pop();
  }

  Widget _decideImageView(){
    if(imageFile == null) {
      return const Text("No Selected Image!");
    } else {
      return Image.file(File(imageFile.path),width: 400, height: 400);
    }
  }

  //This method does not do anything right now,
  updateProfilePhoto(Image image) {
    if (image == null){
      Error error = Error();
    } else {
      //Set the user's profile photo to image in firebase, then
      //refresh the avatar, maybe call profilePicture() again somehow.
    }
  }

}*/