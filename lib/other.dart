import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'fuck',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // The list that contains information about photos
  List _loadedItems = [];

  // The function that fetches data from the API
  Future<void> _fetchData() async {
    const API_URL = 'https://kulturarvsdata.se/ksamsok/api?method=search&version=1.1&hitsPerPage=500&query=text=runsten';

    final response = await http.get(Uri.parse(API_URL));
    final document = XmlDocument.parse((response.body));

    setState(() {
      _loadedItems = document.children;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('no'),
        ),
        body: SafeArea(
            child: _loadedItems.length == 0
                ? Center(
              child: ElevatedButton(
                child: Text('press'),
                onPressed: _fetchData,
              ),
            )
            // The ListView that displays photos
                : ListView.builder(
              itemCount: _loadedItems.length,
              itemBuilder: (BuildContext ctx, index) {
                return ListTile(
                  title: Text(_loadedItems.toString())
                );
              },
            )));
  }
}