import 'dart:math';

import 'package:cellulo_hub/main/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'custom.dart';

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
}

ExpansionPanel gameExpansionPanel(
    List<Game> _gamesList, int _index, bool _myGames, BuildContext _context,
    {Function? onPressedMain, Function? onPressedSecond}) {
  Game _game = _gamesList[_index];
  return ExpansionPanel(
      headerBuilder: (context, isOpen) => gameHeaderBuilder(_gamesList, _index, _myGames, _context),
      body: gameBody(_game, _myGames, onPressedMain: onPressedMain, onPressedSecond: onPressedSecond),
      isExpanded: _game.isExpanded,
      canTapOnHeader: true,
      hasIcon: false);
}

Widget gameHeaderBuilder(
    List<Game> _gamesList, int _index, bool _myGames, BuildContext _context) {
  Game _game = _gamesList[_index];
  double _height = 150;
  return Stack(
    children: [
      Container(
        child: SizedBox(
            height: _height,
            child: Center(
                child: Text(
              _game.name,
              style: Style.gameStyle(),
            ))),
        decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter:
                  _game.isInstalled || _game.webUrl != null || !_myGames
                      ? null
                      : ColorFilter.mode(
                          Colors.black.withOpacity(.8), BlendMode.darken),
              image: Image.network(_game.backgroundImage).image,
              fit: BoxFit.fitWidth),
        ),
      ),
      _game.isExpanded
          ? SizedBox(
              height: _height,
              child: Column(
                children: [
                  _androidTag(_game, _context),
                  _linuxTag(_game, _context),
                  _webTag(_game, _context),
                ],
              ),
            )
          : ((_game.webUrl != "" || Custom.canBeInstalledOnThisPlatform(_game))
              ? Container()
              : SizedBox(
                  height: 150,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: _unavailableTag(_context))))
    ],
  );
}

Widget gameBody(Game _game, bool _myGames,
    {Function? onPressedMain, Function? onPressedSecond}) {
  return Container(
    width: 500,
    alignment: Alignment.center,
    child: Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(15), //apply padding to all four sides
            child: Text(_game.description, style: Style.descriptionStyle())),
        Padding(
            padding: const EdgeInsets.all(15), //apply padding to all four sides
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _physicalPercentage(_game),
              const SizedBox(width: 30),
              _cerebralPercentage(_game),
              const SizedBox(width: 30),
              _socialPercentage(_game),
            ])),
        Padding(
            padding: const EdgeInsets.all(15), //apply padding to all four sides
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: Custom.elevatedColorStyle(),
                    onPressed:
                        _myGames && !Custom.canBeInstalledOnThisPlatform(_game)
                            ? null
                            : () => onPressedMain!(_game),
                    child: _myGames
                        ? Text(_game.isInstalled ? "Uninstall" : "Install")
                        : Text(_game.isInLibrary
                            ? "See in library"
                            : "Add to My Games")),
                _myGames ? const SizedBox(width: 30) : Container(),
                _myGames
                    ? ElevatedButton(
                        style: Custom.elevatedColorStyle(),
                        onPressed: (_game.isInstalled || _game.webUrl != "")
                            ? () => onPressedSecond!(_game)
                            : null,
                        child: const Text("Launch"))
                    : Container(),
              ],
            ))
      ],
    ),
  );
}

//TODO generalize ElevatedButton.icon inside Common
Widget _androidTag(Game _game, BuildContext _context) {
  return _elevatedButtonTag(
      _game.androidBuild != null, _context, "Android", Colors.greenAccent);
}

Widget _linuxTag(Game _game, BuildContext _context) {
  return _elevatedButtonTag(
      _game.linuxBuild != null, _context, "Linux", Colors.amber);
}

Widget _webTag(Game _game, BuildContext _context) {
  return _elevatedButtonTag(
      _game.webUrl != null, _context, "Web", Colors.lightBlueAccent);
}

ElevatedButton _elevatedButtonTag(
    bool _available, BuildContext _context, String _platform, Color _color) {
  return ElevatedButton.icon(
    onPressed: () => _available
        ? _showTagSnack(_context, "This game is available on" + _platform)
        : _showTagSnack(_context, "This game is not available on" + _platform),
    icon: Icon(
      FontAwesome.android,
      color: _available ? Colors.white : Colors.black,
    ),
    label: Text(_platform, style: Style.tagStyle(_available, false)),
    style: ElevatedButton.styleFrom(
        primary: _available ? _color : Colors.grey.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        fixedSize: const Size(150, 30)),
  );
}

Widget _unavailableTag(BuildContext _context) {
  return ElevatedButton.icon(
    onPressed: () =>
        _showTagSnack(_context, "This game is not available on this platform"),
    icon: const Icon(
      FontAwesome.warning,
      color: Colors.white,
    ),
    label: Text(
      'Not available on your device',
      style: Style.tagStyle(true, true),
      textAlign: TextAlign.center,
    ),
    style: ElevatedButton.styleFrom(
      primary: Colors.blueGrey,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0))),
      fixedSize: const Size(180, 50),
    ),
  );
}

//TODO fix spamming tag
void _showTagSnack(BuildContext _context, String _text) {
  final snackBar = Custom.checkSnackBar(_text);
  ScaffoldMessenger.of(_context).showSnackBar(snackBar);
  Future.delayed(const Duration(seconds: 3),
      () => ScaffoldMessenger.of(_context).hideCurrentSnackBar());
}

//TODO generalize AnimatedBuilder
Widget _physicalPercentage(Game _game) {
  return AnimatedBuilder(
    animation: Custom.percentageController,
    builder: (BuildContext context, Widget? child) {
      return CircularPercentIndicator(
              circularStrokeCap: CircularStrokeCap.round,
              radius: 40.0,
              lineWidth: 5.0,
              percent: min(Custom.percentageController.value, _game.physicalPercentage),
              center: const Icon(
                Ionicons.ios_fitness,
                color: Colors.deepOrangeAccent,
                size: 30,
              ),
              progressColor: Colors.deepOrangeAccent,
              backgroundColor: Colors.grey.shade200,
            );
    },
  );
}

Widget _cerebralPercentage(Game _game) {
  return AnimatedBuilder(
    animation: Custom.percentageController,
    builder: (BuildContext context, Widget? child) {
      return CircularPercentIndicator(
        circularStrokeCap: CircularStrokeCap.round,
        radius: 40.0,
        lineWidth: 5.0,
        percent: min(Custom.percentageController.value, _game.cognitivePercentage),
        center: const Icon(
          MaterialCommunityIcons.brain,
          color: Colors.lightBlueAccent,
          size: 30,
        ),
        progressColor: Colors.lightBlueAccent,
        backgroundColor: Colors.grey.shade200,
      );
    },
  );
}

Widget _socialPercentage(Game _game) {
  return AnimatedBuilder(
    animation: Custom.percentageController,
    builder: (BuildContext context, Widget? child) {
      return CircularPercentIndicator(
        circularStrokeCap: CircularStrokeCap.round,
        radius: 40.0,
        lineWidth: 5.0,
        percent: min(Custom.percentageController.value, _game.socialPercentage),
        center: const Icon(
          MaterialIcons.people,
          color: Colors.greenAccent,
          size: 30,
        ),
        progressColor: Colors.greenAccent,
        backgroundColor: Colors.grey.shade200,
      );
    },
  );
}
