import 'package:cellulo_hub/api/flutterfire_api.dart';
import 'package:cellulo_hub/charts/time_played_chart.dart';
import 'package:flutter/material.dart';
import 'time_played_series.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TimePlayedDataBuilder{

  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  static int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  static int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy =  ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(date.year - 1);
    } else if (woy > numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }

  static bool isThisWeek(DateTime date){
    DateTime now = DateTime.now();
    return date.year == now.year && weekNumber(date) == weekNumber(now);
  }

  /*/// Create the data for the charts from the time played for each day of the current week
  static Future<List<TimePlayedSeries>> buildData() async{
    List<TimePlayedSeries> output = List.empty();

    var week = await FlutterfireApi.getUserTimePlayedThisWeek();
    for(String day in week.keys){
      print('$day: ${week[day]!}');
      output.add(TimePlayedSeries(
        timePlayed: week[day]!,
        dayOfTheWeek: day,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue))
      );
    }
    return output;
  }*/

  /// Build the number of hours per week played
  static Future<Widget> buildData() async{
    List<TimePlayedSeries> output = List.empty(growable: true);

    var week = await FlutterfireApi.getUserTimePlayedThisWeek();
    for(String day in week.keys){
      TimePlayedSeries toAdd = TimePlayedSeries(
          timePlayed: week[day]!,
          dayOfTheWeek: day,
          barColor: charts.ColorUtil.fromDartColor(Colors.blue));
      output.add(toAdd);
    }
    return TimePlayedChart(data: output);
  }

}