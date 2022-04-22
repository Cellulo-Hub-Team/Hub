import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../common.dart';
import '../game.dart';
import '../style.dart';

//The bottom expanded part of the game panel
class GameBody extends StatefulWidget {
  final Game game;
  final bool inMyGames;
  final Function? onPressedPrimary;
  final Function? onPressedSecondary;
  const GameBody({Key? key,
    required this.game,
    required this.inMyGames,
    this.onPressedPrimary,
    this.onPressedSecondary}) : super(key: key);

  @override
  State<GameBody> createState() => _GameBodyState();
}

class _GameBodyState extends State<GameBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      alignment: Alignment.center,
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(15), //apply padding to all four sides
              child: Text(widget.game.description, style: Style.descriptionStyle())),
          Padding(
              padding: const EdgeInsets.all(15), //apply padding to all four sides
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _percentageIndicator(widget.game.physicalPercentage, Colors.deepOrangeAccent, Ionicons.ios_fitness),
                const SizedBox(width: 30),
                _percentageIndicator(widget.game.cognitivePercentage, Colors.lightBlueAccent, MaterialCommunityIcons.brain),
                const SizedBox(width: 30),
                _percentageIndicator(widget.game.socialPercentage, Colors.greenAccent, MaterialIcons.people),
              ])),
          Padding(
              padding: const EdgeInsets.all(15), //apply padding to all four sides
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: Common.elevatedColorStyle(),
                      onPressed: () {},
                      /*widget.inMyGames && !Common.canBeInstalledOnThisPlatform(widget.game)
                          ? null
                          : widget.onPressedPrimary!(widget.game),*/
                      child: widget.inMyGames
                          ? Text(widget.game.isInstalled ? "Uninstall" : "Install")
                          : Text(widget.game.isInLibrary
                          ? "See in library"
                          : "Add to My Games")),
                  widget.inMyGames ? const SizedBox(width: 30) : Container(),
                  widget.inMyGames
                      ? ElevatedButton(
                      style: Common.elevatedColorStyle(),
                      onPressed: () {},/*(widget.game.isInstalled || widget.game.webUrl != "")
                          ? widget.onPressedSecondary!(widget.game)
                          : null,*/
                      child: const Text("Launch"))
                      : Container(),
                ],
              ))
        ],
      ),
    );
  }

  Widget _percentageIndicator(double _percentage, Color _color, IconData _icon) {
    return AnimatedBuilder(
      animation: Common.percentageController,
      builder: (BuildContext context, Widget? child) {
        return CircularPercentIndicator(
          circularStrokeCap: CircularStrokeCap.round,
          radius: 40.0,
          lineWidth: 5.0,
          percent: min(Common.percentageController.value, _percentage),
          center: Icon(
            _icon,
            color: _color,
            size: 30,
          ),
          progressColor: _color,
          backgroundColor: Colors.grey.shade200,
        );
      },
    );
  }
}
