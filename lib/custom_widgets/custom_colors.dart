import 'package:flutter/material.dart';

import '../main.dart';
import '../main/common.dart';

Map<int, Color> _redMap = {
  900: const Color.fromRGBO(253, 99, 125, 1),
};
Map<int, Color> _greenMap = {
  900: const Color.fromRGBO(1, 219, 169, 1),
};
Map<int, Color> _blueMap = {
  900: const Color.fromRGBO(14, 208, 218, 1),
};
Map<int, Color> _yellowMap = {
  900: const Color.fromRGBO(248, 200, 80, 1),
};
Map<int, Color> _purpleMap = {
  900: const Color.fromRGBO(172, 46, 208, 1),
};
Map<int, Color> _greyMap = {
  900: const Color.fromRGBO(100, 100, 100, 1),
};
Map<int, Color> _blackMap = {
  900: const Color.fromRGBO(50, 50, 50, 1),
};

class CustomColors{
  static MaterialColor redColor = MaterialColor(0x000000, _redMap);
  static MaterialColor greenColor = MaterialColor(0x000000, _greenMap);
  static MaterialColor blueColor = MaterialColor(0x000000, _blueMap);
  static MaterialColor yellowColor = MaterialColor(0x000000, _yellowMap);
  static MaterialColor purpleColor = MaterialColor(0x000000, _purpleMap);
  static MaterialColor greyColor = MaterialColor(0x000000, _greyMap);
  static MaterialColor blackColor = MaterialColor(0x000000, _blackMap);

  //The main color in the current part of the app
  static Color currentColor = redColor;

  //The default color adapted to each theme
  static Color darkThmeColor = Common.darkTheme ? Colors.white : blackColor.shade900;

  //The default color adapted to each theme inversed
  static Color inversedDarkThmeColor = Common.darkTheme ? blackColor.shade900 : Colors.white;
}


