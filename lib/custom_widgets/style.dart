import 'package:cellulo_hub/custom_widgets/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  static TextStyle titleStyle() =>
      GoogleFonts.comfortaa(fontSize: 30, color: CustomColors.darkThemeColor());
  static TextStyle bannerStyle() => GoogleFonts.fredokaOne(
      fontSize: 50,
      color: Colors.white,
      shadows: [const Shadow(offset: Offset(3, 3))]);
  static TextStyle iconButtonStyle(bool _isAvailable) => GoogleFonts.comfortaa(
      fontSize: 20, color: _isAvailable ? Colors.white : Colors.black);
  static TextStyle tabStyle() => GoogleFonts.comfortaa(fontSize: 15);
  static TextStyle snackStyle() =>
      GoogleFonts.comfortaa(fontSize: 20, color: Colors.white);
  static TextStyle descriptionStyle() =>
      GoogleFonts.comfortaa(fontSize: 20, color: CustomColors.darkThemeColor());
  static TextStyle achievementStyle() =>
      GoogleFonts.comfortaa(fontSize: 30, color: CustomColors.darkThemeColor());
}
