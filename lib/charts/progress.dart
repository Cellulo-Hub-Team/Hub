import 'dart:math';

import 'package:cellulo_hub/api/flutterfire_api.dart';
import 'package:cellulo_hub/charts/time_played_chart.dart';
import 'package:cellulo_hub/charts/time_played_data_builder.dart';
import 'package:cellulo_hub/charts/time_played_series.dart';
import 'package:cellulo_hub/main/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../custom_widgets/custom_colors.dart';
import '../custom_widgets/custom_scaffold.dart';
import '../game/game.dart';
import '../main.dart';
import '../main/common.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Progress extends StatefulWidget {
  const Progress({Key? key}) : super(key: key);

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  double _width = 0;
  double _height = 200;

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.redColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _width = min(MediaQuery.of(context).size.width, 1000) / 4;
    //final List<TimePlayedSeries> data = TimePlayedDataBuilder.buildData(map) as List<TimePlayedSeries>;
    /*final List<TimePlayedSeries> data = [
      TimePlayedSeries(
          timePlayed: 2,
          dayOfTheWeek: 'Monday',
          barColor: charts.ColorUtil.fromDartColor(Colors.blue)),
      TimePlayedSeries(
          timePlayed: 1,
          dayOfTheWeek: 'Tuesday',
          barColor: charts.ColorUtil.fromDartColor(Colors.blue)),
      TimePlayedSeries(
          timePlayed: 3,
          dayOfTheWeek: 'Wednesday',
          barColor: charts.ColorUtil.fromDartColor(Colors.blue)),
      TimePlayedSeries(
          timePlayed: 5,
          dayOfTheWeek: 'Thursday',
          barColor: charts.ColorUtil.fromDartColor(Colors.blue)),
      TimePlayedSeries(
          timePlayed: 6,
          dayOfTheWeek: 'Friday',
          barColor: charts.ColorUtil.fromDartColor(Colors.blue)),
      TimePlayedSeries(
          timePlayed: 2,
          dayOfTheWeek: 'Saturday',
          barColor: charts.ColorUtil.fromDartColor(Colors.blue)),
      TimePlayedSeries(
          timePlayed: 2,
          dayOfTheWeek: 'Sunday',
          barColor: charts.ColorUtil.fromDartColor(Colors.blue))
    ];*/

    return CustomScaffold(
        name: "Progress",
        leadingIcon: Ionicons.ios_settings,
        leadingName: "Settings",
        leadingScreen: Activity.Settings,
        leadingTarget: const Settings(),
        hasFloating: false,
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: 500,
              child: FutureBuilder(
                  future: TimePlayedDataBuilder.buildData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    } else {
                      return const CircularProgressIndicator();
                    }
                  })),
          SizedBox(height: 20,),
          Text('Total hours played overall = ${Common.getTotalTimePlayed() / 60.0}h'),
            FutureBuilder(
                future: FlutterfireApi.timePlayedThisWeek(),
                builder:
                    (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('Total hours played this week = ${(snapshot.data as double).toStringAsFixed(1)}h');
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),


        ]))));
  }

  Widget _podiumStep(double _offset, int _index, Game _game) {
    return Column(
      children: [
        Container(
          height: _offset,
          width: _width,
        ),
        Container(
          child: SizedBox(
              height: 100,
              width: _width,
              child: Center(
                  child: Text(
                _game.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.fredokaOne(
                    fontSize: 32,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        offset: Offset(3, 3),
                      )
                    ]),
              ))),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.network(_game.backgroundImage).image,
                fit: BoxFit.cover),
          ),
        ),
        Container(
          color: Color.fromRGBO(0xFF, 0x40, 0x40, 1),
          width: _width,
          height: 30,
          child: _index == 1
              ? const Icon(MaterialCommunityIcons.medal,
                  size: 28, color: Colors.white)
              : Center(
                  child: Text(_index == 0 ? '2nd' : '3rd',
                      style: TextStyle(color: Colors.white))),
        ),
        Expanded(
            child: Container(
                decoration: BoxDecoration(
                  gradient: _index != 1
                      ? LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            _index < 1
                                ? Color.fromRGBO(0xFF, 0x70, 0x70, 1)
                                : Color.fromRGBO(0xFF, 0x50, 0x50, 1),
                            _index > 1
                                ? Color.fromRGBO(0xFF, 0x70, 0x70, 1)
                                : Color.fromRGBO(0xFF, 0x50, 0x50, 1),
                          ],
                        )
                      : null,
                  color:
                      _index == 1 ? Color.fromRGBO(0xFF, 0x68, 0x68, 1) : null,
                ),
                height: _height,
                width: _width,
                child: const Center(
                    child: Text('Time played : 20h',
                        style: TextStyle(color: Colors.white, fontSize: 15))))),
      ],
    );
  }
}
