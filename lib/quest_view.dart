import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photo_quest/completed_quests.dart';
import 'package:photo_quest/quest_tab.dart';
import 'main.dart';
import 'quest.dart';
import 'quest_map.dart';
import 'quest_list.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:camera/camera.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'dart:html';

class QuestBox extends StatefulWidget{
  const QuestBox({Key? key}) : super(key: key);
  State<QuestBox> createState() => QuestBoxState();

}
class QuestBoxState extends State<QuestBox> {

  final user = FirebaseAuth.instance.currentUser!;
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();

  Future<void> _showChoiceDialog(BuildContext context, QuestNode node) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Upload photo:"),
        content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text("Gallery"),
                  onTap: (){
                    _openGallery(context, node);
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0),),
                GestureDetector(
                  child: const Text("Camera"),
                  onTap: (){
                    _openCamera(context, node);
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

  _openGallery(BuildContext context, QuestNode node) async {
    XFile? picture = await imagePicker.pickImage(source: ImageSource.gallery);
    //setState((){
    imageFile = picture as XFile;
    //});
    Navigator.of(context).pop();
    _uploadPhoto(imageFile, node);
  }

  _openCamera(BuildContext context, QuestNode node) async {
    XFile? picture = await imagePicker.pickImage(source: ImageSource.camera);

    //setState((){
    imageFile = picture as XFile;
    //});
    Navigator.of(context).pop();
    _uploadPhoto(imageFile, node);
    //return imageFile;
  }

  void _uploadPhoto(XFile image, QuestNode node) async {
    //Takes an image and uploads it to FirebaseAuth.instance.currentUser's image-storage

    //reference to image.jpg
    final imageRef = storageRef.child(node.name + ".jpg");

    //reference to users/uid/image.jpg
    //"image.jpg" should be "the name of the quest".jpg
    final usersImageRef = storageRef.child("users/" + user.uid + "/" + node.name + ".jpg");

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
    _showFeedback(node);
  }

  static List<QuestNode> nodes = [];

  @override
  void initState(){
    super.initState();
    setState(() {
      nodes = QuestNodeList().getQuestNodes();
    });
  }



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: nodes.length,
        itemBuilder: (BuildContext context, int index) {
          Image image = Image.asset(nodes[index].getImage(), height: 70,
            width: 70,);
          return Card(
            child: Container(
              decoration: BoxDecoration(image: DecorationImage(image: image.image,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    title: Text(nodes[index].name,
                      style: TextStyle(fontSize: 25, color: Colors.white),
                      textAlign: TextAlign.center,),
                    subtitle: Text(nodes[index].description + "\n" + QuestNodeList().getDistance(QuestNodeList.currentCoordinates, nodes[index].getCoordinates()),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                          child: const Text('TAKE PHOTO',
                            style: TextStyle(fontSize: 15, color: Colors
                                .black),),
                          onPressed: () async {
                            _showChoiceDialog(context, nodes[index]);
                          }
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                          child: const Text('SELECT QUEST',
                            style: TextStyle(fontSize: 15, color: Colors
                                .black),),
                          onPressed: () {
                            QuestNodeList.selectedNodes.forEach((node) {node.decline();});
                            QuestNodeList.availableQuests.forEach((node) {node.decline();});
                            QuestNodeList().select(nodes[index]);
                            nodes[index].accept();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context)=> const QuestMapPage()
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
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          );}
    );
  }

  void _showFeedback(QuestNode node) async{
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Quest completed!"),
            actions: <Widget>[
              ElevatedButton(
                  child: const Text("OK"), ///closes window
                  onPressed: () {
                    QuestNodeList().addCompletedList(node);
                    setState(() {
                      QuestBoxState.nodes.remove(node);
                    });
                    Navigator.of(context).pop();
                    initState();
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
}

/*Card(child: ListTile(
        isThreeLine: true,
        title: Text(
            item.name + "\n" + item.type + "\n" + item.description),
        subtitle: Text(item.coordinate)
    ))*/





