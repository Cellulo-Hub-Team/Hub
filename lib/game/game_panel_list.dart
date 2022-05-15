import 'package:flutter/material.dart';

import '../main/common.dart';
import 'game.dart';
import 'game_body.dart';
import 'game_header.dart';


//The list of expandable game panels
class GamePanelList extends StatefulWidget {
  final List<Game> games;
  final Function(Game)? onPressedPrimary;
  final Function(Game)? onPressedSecondary;
  final Function(Game)? onPressedTertiary;
  const GamePanelList(
      {Key? key,
      required this.games,
      this.onPressedPrimary,
      this.onPressedSecondary,
      this.onPressedTertiary
      })
      : super(key: key);

  @override
  State<GamePanelList> createState() => _GamePanelListState();
}

class _GamePanelListState extends State<GamePanelList> with TickerProviderStateMixin {

  @override
  void initState() {
    Common.percentageController = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    Common.percentageController.reset();
    Common.percentageController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ExpansionPanel> result = [];
    for (int i = 0; i < widget.games.length; i++) {
      result.add(gameExpansionPanel(widget.games[i], i));
    }
    return Center(child: Container(width: 1000, alignment: Alignment.center, child: ListView(children: [ExpansionPanelList(
        children: result,
        expansionCallback: (i, isOpen) => setState(() {
              for (int j = 0; j < result.length; j++) {
                if (j != i) widget.games[j].isExpanded = false;
              }
              widget.games[i].isExpanded = !isOpen;
              Common.percentageController.reset();
              Common.percentageController.forward();
            }))])));
  }

  //The expandable panel for each game
  ExpansionPanel gameExpansionPanel(Game _game, int _index) {
    return ExpansionPanel(
        headerBuilder: (context, isOpen) =>
        Hero(
          tag: 'game' + _index.toString(),
            child: GameHeader(game: _game)),
        body: GameBody(
            game: _game,
            index: _index,
            isDescription: false,
            onPressedPrimary: Common.currentScreen == Activity.MyGames && !Common.canBeInstalledOnThisPlatform(_game)
                ? null
                : () => widget.onPressedPrimary!(_game),
            onPressedSecondary: !_game.isInstalled && _game.webUrl == null
                ? null
                : () => widget.onPressedSecondary!(_game),
          onPressedTertiary: () => widget.onPressedTertiary!(_game),
        ),
        isExpanded: _game.isExpanded,
        canTapOnHeader: true,
        hasIcon: false);
  }
}
