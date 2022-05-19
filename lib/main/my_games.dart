import 'dart:async';

import 'package:cellulo_hub/api/shell_scripts.dart';
import 'package:cellulo_hub/custom_widgets/custom_scaffold.dart';
import 'package:cellulo_hub/game/game_panel_list.dart';
import 'package:cellulo_hub/main.dart';
import 'package:cellulo_hub/main/shop.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import '../api/flutterfire_api.dart';
import '../api/firedart_api.dart';
import 'common.dart';
import '../custom_widgets/custom_colors.dart';
import '../game/game.dart';

//User games library
class MyGames extends StatefulWidget {
  const MyGames({Key? key}) : super(key: key);

  @override
  _MyGamesState createState() => _MyGamesState();
}

class _MyGamesState extends State<MyGames>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Game? _beingInstalledGame;
  List<Game> inLibraryGames =
      Common.allGamesList.where((game) => game.isInLibrary).toList();

  ///Installs the game on the device
  _onPressedInstall(Game _game) async {
    //TODO add iOS and MacOS
    if (Common.isDesktop) {
      if (_game.isInstalled) {
        setState(() {
          _game.downloading = 1;
        });
        ShellScripts.uninstallGameWindows(_game)
            .whenComplete(() => setState(() {
                  _game.isInstalled = false;
                  _game.downloading = 0;
                }));
      } else {
        setState(() {
          _game.downloading = 1;
        });
        ShellScripts.installGame(_game)
            .whenComplete(() => setState(() {
              _game.isInstalled = true;
              _game.downloading = 0;
            }));
      }
    } else if (Common.isAndroid) {
      _beingInstalledGame = _game;
      if (_game.isInstalled) {
        DeviceApps.uninstallApp(FlutterfireApi.createPackageName(_game));
      } else {
        if (await Common.isConnected()) {
          await FlutterfireApi.downloadFile(_game);
        } else {
          Common.showSnackBar(
              context, 'Please connect the device to the Internet');
        }
      }
    }
  }

  ///Launches the installed game or the web game if no game can be installed on this platform
  _onPressedLaunch(Game _game) {
    if (!_game.isInstalled) {
      FlutterfireApi.launchWebApp(_game);
    } else {
      Common.isDesktop
          ? FiredartApi.launchApp(_game)
          : FlutterfireApi.launchApp(_game);
    }
  }

  ///Delete game from my games
  _onPressedDelete(Game _game) async {
    if (_game.isInLibrary) {
      if (Common.isDesktop) {
        await FiredartApi.removeFromUserLibrary(_game);
        if (_game.isInstalled) {
          ShellScripts.uninstallGameWindows(_game)
              .whenComplete(() => setState(() {
            _game.isInstalled = false;
          }));
        }
      } else {
        await FlutterfireApi.removeFromUserLibrary(_game, context);
        if (_game.isInstalled) {
          DeviceApps.uninstallApp(FlutterfireApi.createPackageName(_game));
        }
      }
      setState(() {
        inLibraryGames =
            Common.allGamesList.where((game) => game.isInLibrary).toList();
      });
    }
  }

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.greenColor();
    WidgetsBinding.instance?.addObserver(this);

    Common.percentageController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    Common.percentageController.reset();
    Common.percentageController.forward();
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

    if (state == AppLifecycleState.resumed && _beingInstalledGame != null) {
      if (await DeviceApps.isAppInstalled(
          FlutterfireApi.createPackageName(_beingInstalledGame!))) {
        setState(() {
          _beingInstalledGame!.isInstalled = true;
        });
      } else {
        setState(() {
          _beingInstalledGame!.isInstalled = false;
        });
      }
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
          games: inLibraryGames,
          onPressedPrimary: _onPressedInstall,
          onPressedSecondary: _onPressedLaunch,
          onPressedTertiary: _onPressedDelete,
        ));
  }
}
