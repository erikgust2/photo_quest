import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_quest/generated/l10n.dart';
import 'package:photo_quest/quest_controller.dart';

class QuestAvailable extends StatelessWidget{
  const QuestAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: QuestController().buildAvailable(context)
    );
  }

}