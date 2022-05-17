import 'dart:convert';
import 'dart:io';

import 'package:process_run/shell.dart';
import 'package:process_run/which.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'account/profile.dart';
import 'custom_widgets/custom_menu_button.dart';
import 'custom_widgets/custom_icon_button.dart';
import 'custom_widgets/style.dart';
import 'main/common.dart';
import 'custom_widgets/custom_colors.dart';
import 'main/my_games.dart';
import 'main/progress.dart';
import 'main/shop.dart';
import 'main/welcome_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Achievement {
  final String label;
  final String type;
  final int steps;
  final int value;

  const Achievement({
    required this.label,
    required this.type,
    required this.steps,
    required this.value});

  factory Achievement.fromJson(Map<String, dynamic> json){
    return Achievement(
      label : json['label'] as String,
      type : json['type'] as String,
      steps : json['steps'] as int,
      value : json['value'] as int
    );
  }
}

void main() async {
  String? _appData = Platform.environment['APPDATA']?.replaceAll(r"\", "/").replaceAll("/Roaming", "");
  print(_appData! + "/LocalLow/Chili/Achievements/achievements.json");
  var path = _appData + "/LocalLow/Chili/Achievements/achievements.json";
  int _index = 0;
  int _count = 0;
  int _minutes = 0;
  List<Achievement> _achievementsList = [];
  await File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .forEach((line) {
        if (_index == 0){
          _count = int.parse(line);
          _index++;
          return;
        }
        if (_index == _count + 1){
          _minutes = int.parse(line);
          return;
        }
        Map<String, dynamic> achievementMap = jsonDecode(line);
        _achievementsList.add(Achievement.fromJson(achievementMap));
        print("${Achievement.fromJson(achievementMap).label} (${Achievement.fromJson(achievementMap).value}/${Achievement.fromJson(achievementMap).steps})");
        _index++;

  });

  /*

  print("Time played: ${_minutes} minutes");
  for (var _achievement in _achievementsList){
    if (_achievement.type == "one"){
      print(_achievement.label);
      return;
    }
    if (_achievement.type == "multiple"){
      print("${_achievement.label} (${_achievement.value}/${_achievement.steps})");
      return;
    }
    print(_achievement.label);
  }
  */

  WidgetsFlutterBinding.ensureInitialized();

  FirebaseAuth.initialize('AIzaSyB-rpiGCDAUXScHzmUXAhaIuSTJ5cP7SwE', VolatileStore());
  Firestore.initialize('cellulo-hub-games');

  if (kIsWeb) {
    // initialize the facebook javascript SDK
    await FacebookAuth.i.webInitialize(
      appId: "5399562753408881",
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );
  }
  runApp(const MyAppDesktop());
}

class MyAppDesktop extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const MyAppDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  textTheme: GoogleFonts.comfortaaTextTheme(),
                  brightness: Brightness.light),
              darkTheme: ThemeData(
                  textTheme: GoogleFonts.comfortaaTextTheme(),
                  scaffoldBackgroundColor: CustomColors.blackColor,
                  brightness: Brightness.dark),
              themeMode: currentMode,
              home: const WelcomeScreen());
        });
  }
}
