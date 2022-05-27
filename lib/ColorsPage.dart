import 'package:flutter/material.dart';
import 'package:photo_quest/generated/l10n.dart';
import 'main.dart';
import 'CustomThemes.dart';
class ColorsPage extends StatelessWidget {
  const ColorsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: AppBar(
        title: Text(S.of(context).languageLabel),
        centerTitle: true,


      ),
      body: Column(children: [
        TextButton(
          child: Text("Light Mode"),
          onPressed: () => {
    MyApp.of(context)?.setTheme(lightTheme),
    }


        ),
        TextButton(
            child: Text("Dark Mode"),
            onPressed: () => {
              MyApp.of(context)?.setTheme(darkTheme),
            }
        ),
      ],),
    );
  }
}