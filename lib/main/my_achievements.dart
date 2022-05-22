import 'dart:async';

import 'package:cellulo_hub/api/shell_scripts.dart';
import 'package:cellulo_hub/custom_widgets/custom_scaffold.dart';
import 'package:cellulo_hub/game/game_panel_list.dart';
import 'package:cellulo_hub/main.dart';
import 'package:cellulo_hub/main/shop.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import '../api/firedart_api.dart';
import '../api/flutterfire_api.dart';
import '../custom_widgets/custom_colors.dart';
import '../game/game.dart';
import 'common.dart';


class MyAchievements extends StatefulWidget {
  const MyAchievements({Key? key}) : super(key: key);

  @override
  _MyAchievementsState createState() => _MyAchievementsState();
}

class _MyAchievementsState extends State<MyAchievements> with TickerProviderStateMixin, WidgetsBindingObserver {

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.redColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        name: "Achievements",
        leadingIcon: Icons.home,
        leadingName: "Menu",
        leadingScreen: Activity.Menu,
        leadingTarget: const MainMenu(),
        hasFloating: true,
        floatingIcon: Icons.filter_alt,
        floatingLabel: "Sort by",
        onPressedFloating: () {
          //TODO sort by
        },
        body: Container());
  }
}
