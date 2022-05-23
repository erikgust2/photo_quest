import 'package:flutter/material.dart';
import 'package:photo_quest/quest_box.dart';


class QuestList extends StatelessWidget {
  const QuestList({Key? key}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return Scaffold(
        appBar: AppBar(toolbarHeight: 0,),
        body: ListView.builder
          (
            itemCount: 10, //senare itemscount?
            itemBuilder: (BuildContext context, int index) {
              return const QuestBox();
            }
        )

    );
  }
}