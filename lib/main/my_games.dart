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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.currentColor,
        title: const Text('My Games'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: gamesExpansionPanelList(
          Common.allGamesList.where((game) => game.isInLibrary).toList(), true),
    );
  }

  Widget gamesExpansionPanelList(List<Game> _gamesList, bool _inMyGames) {
    List<ExpansionPanel> result = [];
    for (int i = 0; i < _gamesList.length; i++) {
      result.add(gameExpansionPanel(_gamesList, i, true, context, onPressedMain: _onPressedInstall, onPressedSecond: _onPressedLaunch));
    }
    return ListView(children: [
      ExpansionPanelList(
          children: result,
          expansionCallback: (i, isOpen) => setState(() {
            for (int j = 0; j < result.length; j++){
              if (j != i) _gamesList[j].isExpanded = false;
            }
            _gamesList[i].isExpanded = !isOpen;
            Common.percentageController.reset();
            Common.percentageController.forward();
          }))
    ]);
  }
}
