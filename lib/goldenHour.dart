import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class goldenHour {
  goldenHour({
    required this.sunset,
    required this.sunrise,
  });

  int sunset;
  int sunrise;

  factory goldenHour.fromJson(Map<String, dynamic> json) => goldenHour(
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

    return Text("Next golden hour: " + nextGoldenHour.toString());
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
    _friendsTemp = goldenHour.fromJson(data['sys']);

    setState(() {
      friend = _friendsTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(friend == null) {
      return Text("00:00");
    }
    return  friend.buildTitle(context);
  }
}
