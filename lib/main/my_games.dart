import 'dart:math';

import 'package:cellulo_hub/main/shop.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import '../api/firebase_api.dart';
import 'custom.dart';
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
    if (_game.webUrl != "" && !Custom.canBeInstalledOnThisPlatform(_game)) {
      FirebaseApi.launchWebApp(_game);
    } else {
      FirebaseApi.launchApp(_game);
    }
  }

  _onPressedShop() {
    Custom.resetOpenPanels();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Shop()),
    );
  }

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.greenColor.shade900;
    Custom.percentageController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Custom.appBar(context, "My Games", const Icon(Icons.home)),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressedShop,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: gamesExpansionPanelList(
          Custom.allGamesList.where((game) => game.isInLibrary).toList(), true),
    );
  }

  Widget gamesExpansionPanelList(List<Game> _gamesList, bool _inMyGames) {
    List<ExpansionPanel> result = [];
    for (int i = 0; i < _gamesList.length; i++) {
      result.add(gameExpansionPanel(_gamesList, i, true, context, onPressedMain: _onPressedInstall, onPressedSecond: _onPressedLaunch));
    }
    return Center(child: SizedBox(width: min(1000, MediaQuery.of(context).size.width), child: ListView(children: [
      ExpansionPanelList(
          children: result,
          expansionCallback: (i, isOpen) => setState(() {
            for (int j = 0; j < result.length; j++){
              if (j != i) _gamesList[j].isExpanded = false;
            }
            _gamesList[i].isExpanded = !isOpen;
            Custom.percentageController.reset();
            Custom.percentageController.forward();
          }))
    ])));
  }
}
