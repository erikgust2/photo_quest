import 'package:flutter/material.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'CollectionsPage.dart';
import 'QuestPage.dart';
import 'quest_map.dart';
import 'package:provider/provider.dart';
import 'GoogleSignIn.dart';
import 'package:photo_quest/GoogleSignInProvider.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();

  static MyAppState? of(BuildContext context) => context.findAncestorStateOfType<MyAppState>();
}

class MyAppState extends State<MyApp> {

  String _title = 'PhotoQuest';
  Locale _locale = Locale('en');

  void setLocale(Locale value){
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider  (
    create: (context) => GoogleSignInProvider(),
    child: MaterialApp(

      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("en"),
        Locale("sv")
      ],
      title: _title,
      home: MyStatefulWidget(),
      debugShowCheckedModeBanner: false,
      locale: _locale,
    ),
  );
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final screens = [
    const QuestPage(),
    const QuestMapPage(),
    const CollectionsPage(),

  ];

  int _selectedIndex = 0;

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: screens [_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pink[100],
        type:BottomNavigationBarType.fixed,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_police_outlined),
            label: S.of(context).questLabel, //Quest Label
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: S.of(context).mapLabel, //Map Label
          ),

           BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: S.of(context).collectionsLabel, //Collections Label
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}


