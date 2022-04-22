import 'dart:math';

import 'package:cellulo_hub/main/custom_widgets/custom_scaffold.dart';
import 'package:cellulo_hub/main/custom_widgets/game_panel_list.dart';
import 'package:cellulo_hub/main/shop.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import '../api/firebase_api.dart';
import 'common.dart';
import 'custom_colors.dart';
import 'game.dart';

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
    if (_game.webUrl != "" && !Common.canBeInstalledOnThisPlatform(_game)) {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      name: "My Games",
      leading: Icons.home,
      hasFloating: true,
      floating: Icons.add,
      onPressedFloating: () => Common.goToTarget(context, const Shop()),
      child: GamePanelList(games: Common.allGamesList, inMyGames: true, onPressedPrimary: _onPressedInstall, onPressedSecondary: _onPressedLaunch)
    );
  }
}
