import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../api/firebase_api.dart';
import '../game/game_panel_list.dart';
import 'common.dart';
import '../custom_widgets/custom_colors.dart';
import '../game/game.dart';
import 'my_games.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({Key? key, required this.selectedGames}) : super(key: key);

  final List<Game> selectedGames;

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
        await FirebaseApi.addToUserLibrary(_game);
        Common.showSnackBar(context, "Correctly added to My Games!");
      }
    });
  }

  @override
  void initState() {
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
          title: const Text('Search'),
          leading: IconButton(
            icon: Icon(Entypo.shop),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: GamePanelList(games: Common.allGamesList, inMyGames: true));
  }
}
