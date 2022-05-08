
import 'package:cellulo_hub/custom_widgets/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main/common.dart';


class Style{
  static TextStyle titleStyle() => GoogleFonts.fredokaOne(fontSize: 30, color: Common.darkTheme ? Colors.white : CustomColors.greyColor.shade900);
  static TextStyle gameStyle() => GoogleFonts.fredokaOne(fontSize: 50, color: Colors.white, shadows: [const Shadow(offset: Offset(3, 3),)]);
  static TextStyle tagStyle(bool _isAvailable, bool _warningTag) => GoogleFonts.comfortaa(fontSize: _warningTag ? 15 : 20, color: _isAvailable ? Colors.white : Colors.black);
  static TextStyle tabStyle() => GoogleFonts.comfortaa(fontSize: 15);
  static TextStyle snackStyle() => GoogleFonts.comfortaa(fontSize: 20, color: Colors.white);
  static TextStyle descriptionStyle() => GoogleFonts.comfortaa(fontSize: 20, color: Common.darkTheme ? Colors.white : CustomColors.greyColor.shade900);

}

