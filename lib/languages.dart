import 'package:flutter/material.dart';
import 'package:photo_quest/generated/l10n.dart';
import 'main.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: AppBar(
        title: Text(S.of(context).languageLabel),
        centerTitle: true,

      ),
      body: Column(children: [
        TextButton(
          child: Text("Set language to Swedish"),
          onPressed: () => MyApp.of(context)?.setLocale(Locale.fromSubtags(languageCode: 'sv')),

        ),
        TextButton(
          child: Text("Set language to English"),
          onPressed: () => MyApp.of(context)?.setLocale(Locale.fromSubtags(languageCode: 'en')),
        ),
      ],),
    );
  }
}
