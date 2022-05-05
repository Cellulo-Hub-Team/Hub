import 'dart:math';

import 'package:cellulo_hub/main/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../main/common.dart';

class Game {
  String name = "";
  String backgroundImage = "";
  String description = "";
  bool isInstalled = false;
  bool isInLibrary = false;
  bool isExpanded = false;
  String? androidBuild;
  String? linuxBuild;
  String? webUrl;
  double physicalPercentage = 0;
  double cognitivePercentage = 0;
  double socialPercentage = 0;
  String company = "";

  Game(
      this.name,
      this.backgroundImage,
      this.description,
      this.androidBuild,
      this.linuxBuild,
      this.webUrl,
      this.physicalPercentage,
      this.cognitivePercentage,
      this.socialPercentage,
      this.company);

  @override
  String toString() {
    return "Game name: $name";
  }
}