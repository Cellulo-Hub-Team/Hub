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
  900: const Color.fromRGBO(182, 56, 208, 1),
};
Map<int, Color> _greyMap = {
  500: const Color.fromRGBO(100, 100, 100, .4),
  900: const Color.fromRGBO(100, 100, 100, 1),
};
Map<int, Color> _blackMap = {
  900: const Color.fromRGBO(50, 50, 50, 1),
};

Map<int, Color> _contrastedRedMap = {
  900: const Color.fromRGBO(225, 24, 70, 1),
};
Map<int, Color> _contrastedGreenMap = {
  900: const Color.fromRGBO(136, 232, 18, 1),
};
Map<int, Color> _contrastedBlueMap = {
  900: const Color.fromRGBO(1, 87, 234, 1),
};
Map<int, Color> _contrastedYellowMap = {
  900: const Color.fromRGBO(242, 202, 26, 1),
};
Map<int, Color> _contrastedPurpleMap = {
  900: const Color.fromRGBO(255, 0, 189, 1),
};

class CustomColors{
  static Color redColor() => Common.contrastTheme ? MaterialColor(0x000000, _contrastedRedMap).shade900 : MaterialColor(0x000000, _redMap).shade900;
  static Color greenColor() => Common.contrastTheme ? MaterialColor(0x000000, _contrastedGreenMap).shade900 : MaterialColor(0x000000, _greenMap).shade900;
  static Color blueColor() => Common.contrastTheme ? MaterialColor(0x000000, _contrastedBlueMap).shade900 : MaterialColor(0x000000, _blueMap).shade900;
  static Color yellowColor() => Common.contrastTheme ? MaterialColor(0x000000, _contrastedYellowMap).shade900 : MaterialColor(0x000000, _yellowMap).shade900;
  static Color purpleColor() => Common.contrastTheme ? MaterialColor(0x000000, _contrastedPurpleMap).shade900 : MaterialColor(0x000000, _purpleMap).shade900;

  static Color greyColor = MaterialColor(0x000000, _greyMap).shade900;
  static Color blackColor = MaterialColor(0x000000, _blackMap).shade900;

  //The main color in the current part of the app
  static Color currentColor = redColor();

  //The default color adapted to each theme
  static Color darkThemeColor() => Common.darkTheme ? Colors.white : blackColor;

  //The default color adapted to each theme inversed
  static Color inversedDarkThemeColor() => Common.darkTheme ? blackColor : Colors.white;
}


