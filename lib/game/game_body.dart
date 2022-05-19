import 'dart:math';

import 'package:cellulo_hub/custom_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../custom_widgets/style.dart';
import '../main/common.dart';
import 'game.dart';
import 'game_description.dart';

//The bottom expanded part of the game panel
class GameBody extends StatefulWidget {
  final Game game;
  final int index;
  final bool isDescription;
  final VoidCallback? onPressedPrimary;
  final VoidCallback? onPressedSecondary;
  final VoidCallback? onPressedTertiary;
  const GameBody(
      {Key? key,
      required this.game,
      required this.index,
      required this.isDescription,
      this.onPressedPrimary,
      this.onPressedSecondary,
      this.onPressedTertiary})
      : super(key: key);

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
              padding:
                  const EdgeInsets.all(15), //apply padding to all four sides
              child: Text("A game by: " + widget.game.companyName,
                  style: Style.descriptionStyle())),
          Padding(
              padding:
                  const EdgeInsets.all(15), //apply padding to all four sides
              child: Text(widget.game.description,
                  style: Style.descriptionStyle())),
          Padding(
              padding:
                  const EdgeInsets.all(15), //apply padding to all four sides
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Spacer(),
                _percentageIndicator(widget.game.physicalPercentage / 100,
                    Colors.deepOrangeAccent, Ionicons.ios_fitness),
                Spacer(),
                _percentageIndicator(widget.game.cognitivePercentage / 100,
                    Colors.lightBlueAccent, MaterialCommunityIcons.brain),
                Spacer(),
                _percentageIndicator(widget.game.socialPercentage / 100,
                    Colors.greenAccent, MaterialIcons.people),
                Spacer()
              ])),
          Padding(
              padding:
                  const EdgeInsets.all(15), //apply padding to all four sides
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  CustomElevatedButton(
                      label: Common.currentScreen == Activity.MyGames
                          ? (widget.game.isInstalled ? "Uninstall" : "Install")
                          : (widget.game.isInLibrary
                              ? "See in library"
                              : "Add to My Games"),
                      onPressed: widget.onPressedPrimary),
                  Common.currentScreen == Activity.MyGames
                      ? Spacer()
                      : Container(),
                  Common.currentScreen == Activity.MyGames
                      ? CustomElevatedButton(
                          label: "Launch",
                          onPressed: widget.onPressedSecondary,
                        )
                      : Container(),
                  Common.currentScreen == Activity.MyGames
                      ? Spacer()
                      : Container(),
                  Common.currentScreen == Activity.MyGames
                      ? CustomElevatedButton(
                          label: "Remove",
                          onPressed: widget.onPressedTertiary,
                        )
                      : Container(),
                  !widget.isDescription ? Spacer() : Container(),
                  !widget.isDescription
                      ? CustomElevatedButton(
                          label: "See more",
                          onPressed: () => Common.goToTarget(
                              context,
                              GameDescription(
                                game: widget.game,
                                index: widget.index,
                                onPressedPrimary: widget.onPressedPrimary,
                                onPressedSecondary: widget.onPressedSecondary,
                                onPressedTertiary: widget.onPressedTertiary,
                              ),
                              false,
                              Common.currentScreen))
                      : Container(),
                  const Spacer(),
                ],
              ))
        ],
      ),
    );
  }

  Widget _percentageIndicator(
      double _percentage, Color _color, IconData _icon) {
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
          backgroundColor:
              Common.darkTheme ? Colors.grey.shade700 : Colors.grey.shade200,
        );
      },
    );
  }
}
