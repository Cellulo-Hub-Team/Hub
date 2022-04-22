import 'package:cellulo_hub/main/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'custom_colors.dart';
import 'game.dart';
import 'dart:io';

class Custom{
  static bool darkTheme = false;
  static late AnimationController percentageController;
  static List<Game> allGamesList = [];

  static bool get isLinux => !kIsWeb && Platform.isLinux;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isWeb => kIsWeb;

  static void resetOpenPanels() {
    for (var localGame in allGamesList) {
      localGame.isExpanded = false;
    }
  }

  static bool canBeInstalledOnThisPlatform(Game _game) {
    if (isAndroid && _game.androidBuild != "") return true;
    if (isLinux && _game.linuxBuild != "") return true;
    return false;
  }

  //Pop up at bottom of the screen
  static SnackBar checkSnackBar(String _text){
    return SnackBar(
      backgroundColor: CustomColors.currentColor,
      content: Text(_text, style: Style.snackStyle()),
    );
  }

  //Color for ElevatedButton
  static ButtonStyle elevatedColorStyle(){
    return ElevatedButton.styleFrom(primary: CustomColors.currentColor);
  }

  static AppBar appBar(BuildContext _context, String _text, Icon _icon){
    return AppBar(
      centerTitle: true,
      backgroundColor: CustomColors.currentColor,
      title: Text(_text),
      leading: IconButton(
        icon: _icon,
        onPressed: () => Navigator.of(_context).pop(),
      ),
    );
  }



}