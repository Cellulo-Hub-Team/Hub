import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TimePlayedSeries {
  final int timePlayed;
  final String dayOfTheWeek;
  final charts.Color barColor;

  TimePlayedSeries(
      {required this.timePlayed,
      required this.dayOfTheWeek,
      required this.barColor});
}
