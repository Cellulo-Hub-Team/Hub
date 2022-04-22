import 'package:cellulo_hub/main/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'custom_colors.dart';
import 'game.dart';
import 'dart:io';

class Common{
  //The variable storing the current theme state
  static bool darkTheme = false;

  //The controller for the percentages animation
  static late AnimationController percentageController;

  //The list of all games on the shop
  static List<Game> allGamesList = [];

  //Safe version of platform detection methods
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isWeb => kIsWeb;

  //Closes all expanded panels
  static resetOpenPanels() {
    for (var localGame in allGamesList) {
      localGame.isExpanded = false;
    }
  }

  //Returns true if build exists for the current platform (web only returns false)
  static bool canBeInstalledOnThisPlatform(Game _game) {
    if (isAndroid && _game.androidBuild != "") return true;
    if (isLinux && _game.linuxBuild != "") return true;
    return false;
  }

  //Display pop-up at the bottom of the screen
  static showSnackBar(BuildContext _context, String _text) {
    final snackBar = SnackBar(
      backgroundColor: CustomColors.currentColor,
      content: Text(_text, style: Style.snackStyle()),
    );
    ScaffoldMessenger.of(_context).showSnackBar(snackBar);
    Future.delayed(const Duration(seconds: 3),
            () => ScaffoldMessenger.of(_context).hideCurrentSnackBar());
  }

  //Navigate to new screen
  static goToTarget(BuildContext _context, Widget _target) {
    Common.resetOpenPanels();
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => _target),
    );
  }

  //Color for ElevatedButton
  static ButtonStyle elevatedColorStyle(){
    return ElevatedButton.styleFrom(primary: CustomColors.currentColor);
  }

}