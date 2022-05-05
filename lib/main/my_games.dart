import 'dart:math';

import 'package:cellulo_hub/custom_widgets/custom_scaffold.dart';
import 'package:cellulo_hub/game/game_panel_list.dart';
import 'package:cellulo_hub/main.dart';
import 'package:cellulo_hub/main/shop.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import '../api/firebase_api.dart';
import 'common.dart';
import '../custom_widgets/custom_colors.dart';
import '../game/game.dart';

//User games library
class MyGames extends StatefulWidget {
  const MyGames({Key? key}) : super(key: key);

  @override
  _MyGamesState createState() => _MyGamesState();
}

class _MyGamesState extends State<MyGames> with TickerProviderStateMixin {

  //Installs the game on the device
  _onPressedInstall(Game _game) {
    setState(() {
      if (_game.isInstalled) {
        DeviceApps.uninstallApp(FirebaseApi.createPackageName(_game));
      } else {
        FirebaseApi.downloadFile(_game);
      }
      _game.isInstalled = !_game.isInstalled;
    });
  }

  //Launches the installed game or the web game if no game can be installed on this platform
  _onPressedLaunch(Game _game) {
    if (!_game.isInstalled) {
      FirebaseApi.launchWebApp(_game);
    } else {
      FirebaseApi.launchApp(_game);
    }
  }

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.greenColor.shade900;
    Common.percentageController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    Common.percentageController.reset();
    Common.percentageController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      name: "My games",
      leadingIcon: Icons.home,
      leadingName: "Menu",
      leadingScreen: Activity.Menu,
      leadingTarget: MainMenu(),
      hasFloating: true,
      floatingIcon: Icons.add,
      floatingLabel: "Add game",
      onPressedFloating: () {
          Common.goToTarget(context, const Shop(), false, Activity.Shop);
          },
      body: GamePanelList(
          games: Common.allGamesList.where((game) => game.isInLibrary).toList(),
          onPressedPrimary: _onPressedInstall,
          onPressedSecondary: _onPressedLaunch)
    );
  }
}
