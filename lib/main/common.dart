import 'dart:io';

import 'package:cellulo_hub/custom_widgets/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../custom_widgets/custom_colors.dart';
import '../game/game.dart';
import 'achievement.dart';

enum Activity { Menu, MyGames, Shop, Profile, Progress, Achievements, Settings}

class Common {
  //The variable storing the current screen we are in
  static Activity currentScreen = Activity.Menu;

  //The variable storing the current theme state
  static bool darkTheme = false;

  //The variable storing the current high contrast state
  static bool contrastTheme = false;

  //The controller for the percentages animation
  static late AnimationController percentageController;

  //The list of all games on the shop
  static List<Game> allGamesList = [];

  //The list of all games achievements
  static Map<Game, List<Achievement>> allAchievementsMap = {};

  ///Safe version of platform detection methods
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  static bool get isWeb => kIsWeb;
  static bool get isDesktop => isLinux || isWindows;

  ///Closes all expanded panels
  static resetOpenPanels() {
    for (var localGame in allGamesList) {
      localGame.isExpanded = false;
    }
  }

  ///Returns true if build exists for the current platform (web only returns false)
  static bool canBeInstalledOnThisPlatform(Game _game) {
    if (isAndroid && _game.androidBuild != null) return true;
    if (isLinux && _game.linuxBuild != null) return true;
    if (isWindows && _game.windowsBuild != null) return true;
    return false;
  }

  ///Display pop-up at the bottom of the screen
  static showSnackBar(BuildContext _context, String _text) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: CustomColors.currentColor,
      content: Text(_text, style: Style.snackStyle()),
    );
    ScaffoldMessenger.of(_context).hideCurrentSnackBar();
    ScaffoldMessenger.of(_context).showSnackBar(snackBar);
  }

  ///Navigate to new screen
  static goToTarget(BuildContext _context, Widget _target, bool _resetPanels,
      Activity _screen) {
    Common.currentScreen = _screen;
    if (_resetPanels) {
      Common.resetOpenPanels();
    }
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => _target),
    );
  }

  ///Open the file at the given path only on Android
  static openFile(String path) {
    if (isAndroid) {
      OpenFile.open(path);
    }
  }

  static Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
