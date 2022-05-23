import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'quest_list.dart';

class QuestAvailable extends StatelessWidget{
  const QuestAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: QuestList(),
    );
  }

}