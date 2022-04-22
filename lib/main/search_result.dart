import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../api/firebase_api.dart';
import 'custom.dart';
import 'custom_colors.dart';
import 'game.dart';
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
        final snackBar = Custom.checkSnackBar("Correctly added to My Games!");
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Future.delayed(const Duration(seconds: 3),
                () => ScaffoldMessenger.of(context).hideCurrentSnackBar());
      }
    });
  }

  @override
  void initState() {
    Custom.percentageController =
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
        body: gamesExpansionPanelList(widget.selectedGames, false));
  }

  Widget gamesExpansionPanelList(List<Game> _gamesList, bool _inMyGames) {
    List<ExpansionPanel> result = [];
    for (int i = 0; i < _gamesList.length; i++) {
      result.add(gameExpansionPanel(_gamesList, i, false, context, onPressedMain: _onPressedMain));
    }
    return ListView(children: [
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
    ]);
  }
}
