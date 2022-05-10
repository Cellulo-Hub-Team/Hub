import 'package:cellulo_hub/api/firedart_api.dart';
import 'package:cellulo_hub/custom_widgets/custom_scaffold.dart';
import 'package:cellulo_hub/main/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../api/flutterfire_api.dart';
import '../game/game_panel_list.dart';
import 'common.dart';
import '../custom_widgets/custom_colors.dart';
import '../game/game.dart';
import 'my_games.dart';

class SearchResult extends StatefulWidget {
  final List<Game> selectedGames;
  final Function(Game)? onPressedPrimary;

  const SearchResult({Key? key,
    required this.selectedGames,
    required this.onPressedPrimary}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> with TickerProviderStateMixin {
  _onPressedMain(Game _game) {
    setState(() async {
      if (_game.isInLibrary) {
        //resetOpenGamesExpansionPanels();
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyGames()),
        );
      } else {
        _game.isInLibrary = true;
        await Common.isDesktop ? FiredartApi.addToUserLibrary(_game) : FlutterfireApi.addToUserLibrary(_game);
        Common.showSnackBar(context, "Correctly added to My Games!");
      }
    });
  }

  @override
  void initState() {
    Common.percentageController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    Common.percentageController.reset();
    Common.percentageController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(name: "Search result",
        leadingIcon: Entypo.shop,
        leadingName: "Shop",
        leadingScreen: Activity.Shop,
        leadingTarget: const Shop(),
        hasFloating: false,
        body: GamePanelList(
            games: Common.allGamesList,
            onPressedPrimary: widget.onPressedPrimary,
        ));
  }
}
