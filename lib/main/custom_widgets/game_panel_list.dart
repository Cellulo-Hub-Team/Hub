import 'package:cellulo_hub/main/custom_widgets/game_body.dart';
import 'package:cellulo_hub/main/custom_widgets/game_header.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../game.dart';

class GamePanelList extends StatefulWidget {
  final List<Game> games;
  final Function? onPressedPrimary;
  final Function? onPressedSecondary;
  final bool inMyGames;
  const GamePanelList(
      {Key? key,
      required this.games,
      required this.inMyGames,
      this.onPressedPrimary,
      this.onPressedSecondary})
      : super(key: key);

  @override
  State<GamePanelList> createState() => _GamePanelListState();
}

class _GamePanelListState extends State<GamePanelList> with TickerProviderStateMixin {

  @override
  void initState() {
    Common.percentageController = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    Common.percentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ExpansionPanel> result = [];
    for (int i = 0; i < widget.games.length; i++) {
      result.add(gameExpansionPanel(widget.games[i]));
    }
    return ListView(children: [ExpansionPanelList(
        children: result,
        expansionCallback: (i, isOpen) => setState(() {
              for (int j = 0; j < result.length; j++) {
                if (j != i) widget.games[j].isExpanded = false;
              }
              widget.games[i].isExpanded = !isOpen;
              Common.percentageController.reset();
              Common.percentageController.forward();
            }))]);
  }

  ExpansionPanel gameExpansionPanel(Game _game) {
    return ExpansionPanel(
        headerBuilder: (context, isOpen) => GameHeader(game: _game, inMyGames: widget.inMyGames),
        body: GameBody(
            game: _game,
            inMyGames: widget.inMyGames,
            onPressedPrimary: widget.onPressedPrimary,
            onPressedSecondary: widget.onPressedSecondary),
        isExpanded: _game.isExpanded,
        canTapOnHeader: true,
        hasIcon: false);
  }
}
