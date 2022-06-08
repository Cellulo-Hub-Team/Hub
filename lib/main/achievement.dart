import 'dart:convert';
import 'dart:io';

import 'package:cellulo_hub/main/common.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cellulo_hub/api/flutterfire_api.dart';
import 'package:permission_handler/permission_handler.dart';


import '../game/game.dart';

class Achievement {
  final String label;
  final String type;
  final int steps;
  final int value;

  const Achievement(
      {required this.label,
      required this.type,
      required this.steps,
      required this.value});

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
        label: json['label'] as String,
        type: json['type'] as String,
        steps: json['steps'] as int,
        value: json['value'] as int);
  }

  ///Get achievements from local file
  static getAchievements(Game _game) async {
    await Permission.storage.request();
    String path = "";
    int _index = 0;
    int _count = 0;
    if(Common.isDesktop){
      if(Common.isWindows) {
        String? _user = Platform.environment['USERPROFILE']?.replaceAll(r"\", "/");
        path = _user! +
            "/AppData/LocalLow/" +
            _game.unityCompanyName +
            "/" +
            _game.unityName +
            "/achievements.json";
      }
    }
    else if(Common.isAndroid){
      final _storage = await ExtStorage.getExternalStorageDirectory();
      path = _storage +
          "/Android/data/" + FlutterfireApi.createPackageName(_game) + "/files" +
          "/achievements" +
          _game.unityName +
          ".json";
    }
    else {
      return;
    }
    if (!await File(path).exists()) {
      return;
    }

    Common.allAchievementsMap[_game] = [];
    await File(path)
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .forEach((line) {
      if (_index == 0) {
        _count = int.parse(line);
        _index++;
        return;
      }
      if (_index == _count + 1) {
        _game.minutesPlayed = int.parse(line);
        return;
      }
      Map<String, dynamic> achievementMap = jsonDecode(line);
      Common.allAchievementsMap[_game]?.add(Achievement.fromJson(achievementMap));
      _index++;
    });
  }
}
