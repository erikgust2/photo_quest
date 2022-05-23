import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_quest/generated/l10n.dart';

class QuestCompleted extends StatelessWidget{
  const QuestCompleted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: Text(S.of(context).completedLabel),
    );
  }

}