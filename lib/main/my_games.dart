import 'dart:async';
import 'dart:math';

import 'package:cellulo_hub/custom_widgets/custom_scaffold.dart';
import 'package:cellulo_hub/game/game_panel_list.dart';
import 'package:cellulo_hub/main.dart';
import 'package:cellulo_hub/main/shop.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

import '../api/firebase_api.dart';
import 'common.dart';
import '../custom_widgets/custom_colors.dart';
import '../game/game.dart';

//User games library
class MyGames extends StatefulWidget {
  static bool _isNotFocused = false;

  static bool get isNotFocused => _isNotFocused;

  const MyGames({Key? key}) : super(key: key);

  @override
  _MyGamesState createState() => _MyGamesState();

  static set isNotFocused(bool value) {
    _isNotFocused = value;
  }

}

class _MyGamesState extends State<MyGames>
    with TickerProviderStateMixin, WidgetsBindingObserver {

  late Game _beingInstalledGame;

  ///Installs the game on the device
  _onPressedInstall(Game _game) async {
    if (_game.isInstalled) {
      DeviceApps.uninstallApp(FirebaseApi.createPackageName(_game));
    }
    else {
      _beingInstalledGame = _game;
      await FirebaseApi.downloadFile(_game);
    }
  }

  ///Launches the installed game or the web game if no game can be installed on this platform
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
    WidgetsBinding.instance?.addObserver(this);

    Common.percentageController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      print("STATE IS INACTIVE/DETACHED");
    }

    if (state == AppLifecycleState.paused) {
      print("STATE IS PAUSED");
    }
    if (state == AppLifecycleState.resumed) {
      if (await DeviceApps.isAppInstalled(FirebaseApi.createPackageName(_beingInstalledGame))) {
        setState(() {
        _beingInstalledGame.isInstalled = true;
      });
        print('GAME IS INSTALLED');
      }
      else{
        setState(() {
          _beingInstalledGame.isInstalled = false;
        });
        print('GAME IS NOT');

      }
      print("STATE IS RESUMED");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        name: "My games",
        leadingIcon: Icons.home,
        leadingName: "Menu",
        leadingScreen: Activity.Menu,
        leadingTarget: const MainMenu(),
        hasFloating: true,
        floatingIcon: Icons.add,
        floatingLabel: "Add game",
        onPressedFloating: () {
          Common.goToTarget(context, const Shop(), false, Activity.Shop);
        },
        body: GamePanelList(
            games:
                Common.allGamesList.where((game) => game.isInLibrary).toList(),
            inMyGames: true,
            onPressedPrimary: _onPressedInstall,
            onPressedSecondary: _onPressedLaunch));
  }
}
