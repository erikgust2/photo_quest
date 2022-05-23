import 'dart:async';

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
    int sunriseTimeInt = (sunrise * 1000);
    int sunsetTimeInt = (sunset * 1000);

    int timeNowInt = (DateTime.now().millisecondsSinceEpoch);

    DateTime sunsetTime = DateTime.fromMillisecondsSinceEpoch(sunsetTimeInt);
    DateTime sunriseTime = DateTime.fromMillisecondsSinceEpoch(sunriseTimeInt);
    DateTime thisDate = DateTime.fromMillisecondsSinceEpoch(timeNowInt);
    DateTime timeUntilSunset = sunsetTime.subtract(Duration(
        hours: thisDate.hour,
        minutes: thisDate.minute,
        seconds: thisDate.second,
        milliseconds: thisDate.millisecond,
        microseconds: thisDate.microsecond));
    DateTime timeUntilSunrise = sunriseTime.subtract(Duration(
        hours: thisDate.hour,
        minutes: thisDate.minute,
        seconds: thisDate.second,
        milliseconds: thisDate.millisecond,
        microseconds: thisDate.microsecond));
    DateTime correctTime;
    if (timeNowInt < sunsetTimeInt) {
      correctTime = timeUntilSunset;
    } else {
      correctTime = timeUntilSunrise;
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
    var countdownGoldenHour = hourZero +
        '${correctTime.hour}: ' +
        minuteZero +
        '${correctTime.minute}: ' +
        secondZero +
        '${correctTime.second}';

    return Text("Golden hour countdown: " + countdownGoldenHour);
  }
}
