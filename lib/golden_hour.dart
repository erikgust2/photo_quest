import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:photo_quest/themes.dart';

class GoldenHour {
  GoldenHour({
    required this.sunset,
    required this.sunrise,
  });

  int sunset;
  int sunrise;

  factory GoldenHour.fromJson(Map<String, dynamic> json) => GoldenHour(
    sunrise: json["sunrise"],
    sunset: json["sunset"],
  );

  Widget buildTitle(BuildContext context) {
    DateTime sunriseTime = DateTime.fromMillisecondsSinceEpoch(sunrise * 1000);
    int sunsetTimeInt = (sunset * 1000) - 3600000;
    DateTime sunsetTime = DateTime.fromMillisecondsSinceEpoch(sunsetTimeInt);

    int timeNowInt = (DateTime.now().millisecondsSinceEpoch);

    DateTime correctTime;
    if (timeNowInt < sunsetTimeInt) {
      correctTime = sunsetTime;
    } else {
      correctTime = sunriseTime;
    }

    String hourZero = '';
    String minuteZero = '';
    String secondZero = '';
    if (correctTime.hour < 10) {
      hourZero = '0';
    }
    if (correctTime.minute < 10) {
      minuteZero = '0';
    }
    if (correctTime.second < 10) {
      secondZero = '0';
    }

    var nextGoldenHour = hourZero +
        '${correctTime.hour}: ' +
        minuteZero +
        '${correctTime.minute}';

    return Text("Next golden hour: " + nextGoldenHour.toString(),style: TextStyle(fontSize: 12, color: VANILLA_ICE));
  }
}

class GoldenHourController extends StatefulWidget {
  GoldenHourController({
    Key? key,
  }) : super(key: key);

  @override
  State<GoldenHourController> createState() => GoldenHourState();
}


class GoldenHourState extends State<GoldenHourController> {
  var friend;

  @override
  void initState() {
    refreshFriends();
    super.initState();
  }

  Future refreshFriends() async {
    Uri URIOne = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=59.334591&lon=18.063240&appid=fee9eba736a1f6b300edbd1e6244a915');
    final resOne = await http.get(URIOne);
    var data = json.decode(resOne.body);
    var _friendsTemp;
    _friendsTemp = GoldenHour.fromJson(data['sys']);
    if(mounted) {
      setState(() {
        friend = _friendsTemp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(friend == null) {
      return Text("loading...", style: TextStyle(fontSize: 12,));
    }
    return  friend.buildTitle(context);
  }
}
