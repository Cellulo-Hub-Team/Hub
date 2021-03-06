import 'package:cellulo_hub/charts/time_played_series.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TimePlayedChart extends StatelessWidget {
  const TimePlayedChart({Key? key, required this.data}) : super(key: key);

  final List<TimePlayedSeries> data;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<TimePlayedSeries, String>> series = [
      charts.Series(
        id: "Time played",
        data: data,
        domainFn: (TimePlayedSeries series, _) => series.dayOfTheWeek,
        measureFn: (TimePlayedSeries series, _) => series.timePlayed,
        colorFn: (TimePlayedSeries series, _) => series.barColor
      )
    ];
    return Container(
        height: 450,
        child: Card(
          child: Column(
            children: [
              Spacer(),
              Text("Hours played this week",
                  style: Theme.of(context).textTheme.bodyText2),
              Expanded(flex: 10, child: charts.BarChart(series, animate: true)),
              Spacer(),
            ],
          ),
        ));
  }
}
