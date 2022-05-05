import 'dart:math';

import 'package:cellulo_hub/custom_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../main/common.dart';
import 'game.dart';
import '../main/style.dart';
import 'game_description.dart';


//The bottom expanded part of the game panel
class GameBody extends StatefulWidget {
  final Game game;
  final bool inMyGames;
  final int index;
  final VoidCallback? onPressedPrimary;
  final VoidCallback? onPressedSecondary;
  const GameBody({Key? key,
    required this.game,
    required this.inMyGames,
    required this.index,
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
              child: Text("A game by: " + widget.game.company, style: Style.descriptionStyle())),
          Padding(
              padding: const EdgeInsets.all(15), //apply padding to all four sides
              child: Text(widget.game.description, style: Style.descriptionStyle())),
          Padding(
              padding: const EdgeInsets.all(15), //apply padding to all four sides
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Spacer(),
                _percentageIndicator(widget.game.physicalPercentage, Colors.deepOrangeAccent, Ionicons.ios_fitness),
                Spacer(),
                _percentageIndicator(widget.game.cognitivePercentage, Colors.lightBlueAccent, MaterialCommunityIcons.brain),
                Spacer(),
                _percentageIndicator(widget.game.socialPercentage, Colors.greenAccent, MaterialIcons.people),
                Spacer()
              ])),
          Padding(
              padding: const EdgeInsets.all(15), //apply padding to all four sides
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  CustomElevatedButton(
                    label: widget.inMyGames
                        ? (widget.game.isInstalled ? "Uninstall" : "Install")
                        : (widget.game.isInLibrary ? "See in library" : "Add to My Games"),
                    onPressed: widget.onPressedPrimary),
                  widget.inMyGames ? Spacer() : Container(),
                  widget.inMyGames ? CustomElevatedButton(
                    label: "Launch",
                    onPressed: widget.onPressedSecondary,
                  ) : Container(),
                  Spacer(),
                  CustomElevatedButton(
                      label: "See more",
                      onPressed: () => Common.goToTarget(
                          context,
                          GameDescription(game: widget.game, inMyGames: widget.inMyGames, index: widget.index),
                          false,
                          Common.currentScreen
                      )),
                  Spacer(),
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
