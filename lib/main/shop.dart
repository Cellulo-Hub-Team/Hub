import 'dart:math';

import 'package:cellulo_hub/custom_widgets/colored_app_bar.dart';
import 'package:cellulo_hub/main.dart';
import 'package:cellulo_hub/main/search_result.dart';
import 'package:cellulo_hub/main/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../api/firebase_api.dart';
import '../custom_widgets/custom_delegate.dart';
import '../custom_widgets/custom_scaffold.dart';
import '../game/game_body.dart';
import '../game/game_panel_list.dart';
import 'common.dart';
import '../custom_widgets/custom_colors.dart';
import '../custom_widgets/custom_search.dart';
import '../game/game.dart';
import 'measure_size.dart';
import 'my_games.dart';

List<String> gamesNames = Common.allGamesList.map((game) => game.name).toList();

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> with TickerProviderStateMixin {
  bool _trendingDescriptionDisplayed = false;
  String _searchResult = "";

  int _trendingDecriptionIndex = 0;
  final GlobalKey<ScrollSnapListState> _trendingKey = GlobalKey();
  late AnimationController _trendingController;

  var myChildSize = Size.zero;

  //Create sublists for each category
  final List<Game> _physicalGames = Common.allGamesList
      .where((game) =>
          game.physicalPercentage >= game.socialPercentage &&
          game.physicalPercentage >= game.cognitivePercentage)
      .toList();
  final List<Game> _cognitiveGames = Common.allGamesList
      .where((game) =>
          game.cognitivePercentage >= game.socialPercentage &&
          game.cognitivePercentage >= game.physicalPercentage)
      .toList();
  final List<Game> _socialGames = Common.allGamesList
      .where((game) =>
          game.socialPercentage >= game.cognitivePercentage &&
          game.socialPercentage >= game.physicalPercentage)
      .toList();

  //Function called when pressing Add to My Games button
  _onPressedPrimary(Game _game) {
    setState(() async {
      if (_game.isInLibrary) {
        Common.goToTarget(context, MyGames(), false, Activity.MyGames);
      } else {
        setState(() {
          _game.isInLibrary = true;
        });
        await FirebaseApi.addToUserLibrary(_game);
        Common.showSnackBar(context, "Correctly added to My Games!");
      }
    });
  }

  //Function called when pressing search icon
  _onPressedSearch() async {
    final finalResult = await showSearch(
      context: context,
      delegate: CustomSearch(allGames: gamesNames),
    );
    setState(() {
      _searchResult = finalResult!;
      List<Game> _selectedGames = Common.allGamesList
          .where((game) => game.name == _searchResult)
          .toList();
      Common.resetOpenPanels();
      if (_searchResult.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SearchResult(selectedGames: _selectedGames)),
        );
      }
    });
  }

  //Function called when pressing a trending game thumbnail
  _onPressedTrending(int _index) {
    setState(() {
      if (_trendingDescriptionDisplayed && _index == _trendingDecriptionIndex) {
        _trendingController.reverse();
        _trendingDescriptionDisplayed = !_trendingDescriptionDisplayed;
      } else if (!_trendingDescriptionDisplayed) {
        Common.percentageController.reset();
        Common.percentageController.forward();
        _trendingController.reset();
        _trendingController.forward();
        _trendingDecriptionIndex = _index;
        _trendingDescriptionDisplayed = !_trendingDescriptionDisplayed;
      }
      _trendingKey.currentState?.focusToItem(_index);
    });
  }

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.blueColor.shade900;
    Common.percentageController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _trendingController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    Common.percentageController.reset();
    Common.percentageController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      name: "Shop",
      leadingIcon: Icons.home,
      leadingName: "Menu",
      leadingScreen: Activity.Menu,
      leadingTarget: MainMenu(),
      hasFloating: true,
      floatingIcon: Icons.search,
      floatingLabel: "Search",
      onPressedFloating: () => _onPressedSearch(),
      body: DefaultTabController(
        length: 4,
        child: Center(
            child: Container(
                width: 1000,
                alignment: Alignment.center,
                child: NestedScrollView(
                  physics: Common.isWeb
                      ? const ClampingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  headerSliverBuilder: (context, value) {
                    return [
                      AnimatedBuilder(
                          animation: _trendingController,
                          builder: (BuildContext context, Widget? child) {
                            return SliverAppBar(
                                backgroundColor: Common.darkTheme ? CustomColors.blackColor.shade900 : Colors.white,
                                automaticallyImplyLeading: false,
                                leading: null,
                                collapsedHeight: 410,
                                expandedHeight: (_trendingController
                                            .drive(
                                                CurveTween(curve: Curves.ease))
                                            .value *
                                        (myChildSize.height + 30)) +
                                    410,
                                flexibleSpace: FlexibleSpaceBar(
                                    background: Column(children: [
                                      Text("Trending", style: Style.titleStyle()),
                                  _trendingWidget(),
                                  _trendingDescriptionDisplayed
                                      ? _trendingDescription()
                                      : Container(),
                                      Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 100),
                                        child: Divider(color: Colors.black),
                                      ),
                                      Text("Search all games", style: Style.titleStyle()),
                                ])));
                          }),
                      SliverPersistentHeader(
                        delegate: CustomDelegate(
                          TabBar(
                            tabs: [
                              Tab(
                                  icon: const Icon(FontAwesome.gamepad),
                                  child: Text("All", style: Style.tabStyle())),
                              Tab(
                                icon: const Icon(Ionicons.ios_fitness),
                                child:
                                    Text("Physical", style: Style.tabStyle()),
                              ),
                              Tab(
                                icon: const Icon(MaterialCommunityIcons.brain),
                                child:
                                    Text("Cognitive", style: Style.tabStyle()),
                              ),
                              Tab(
                                icon: const Icon(MaterialIcons.people),
                                child: Text("Social", style: Style.tabStyle()),
                              ),
                            ],
                            labelColor: CustomColors.currentColor,
                            indicatorColor: CustomColors.currentColor,
                            unselectedLabelColor: Common.darkTheme
                                ? CustomColors.greyColor.shade900
                                : CustomColors.blackColor.shade900,
                          ),
                        ),
                        floating: true,
                        pinned: true,
                      )
                    ];
                  },
                  body: TabBarView(
                    children: [
                      GamePanelList(
                          games: Common.allGamesList,
                          onPressedPrimary: _onPressedPrimary),
                      GamePanelList(
                          games: _physicalGames,
                          onPressedPrimary: _onPressedPrimary),
                      GamePanelList(
                          games: _cognitiveGames,
                          onPressedPrimary: _onPressedPrimary),
                      GamePanelList(
                          games: _socialGames,
                          onPressedPrimary: _onPressedPrimary),
                    ],
                  ),
                ))),
      ),
    );
  }

  //Trending games list
  Widget _trendingWidget() {
    return SizedBox(
        height: 320,
        child: ScrollSnapList(
          itemBuilder: _buildItemTrendingList,
          itemSize: 300,
          dynamicItemSize: true,
          onReachEnd: () {},
          itemCount: Common.allGamesList.length,
          onItemFocus: (int _index) => {
            setState(() {
              if (_trendingDescriptionDisplayed) {
                _trendingDecriptionIndex = _index;
                Common.percentageController.reset();
                Common.percentageController.forward();
              }
            })
          },
          key: _trendingKey,
        ));
  }

  //Builder for each game in the trending list
  Widget _buildItemTrendingList(BuildContext context, int index) {
    return Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Container(
          width: 300,
          height: 200,
          child: TextButton(
            onPressed: () => _onPressedTrending(index),
            child: Text(
              Common.allGamesList[index].name,
              textAlign: TextAlign.center,
              style: Style.gameStyle(),
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                  image:
                      Image.network(Common.allGamesList[index].backgroundImage)
                          .image,
                  fit: BoxFit.fitHeight),
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  color: Common.darkTheme
                      ? Colors.grey.shade900
                      : Colors.grey.shade300,
                  offset: const Offset(0, 10), // changes position of shadow
                ),
              ]),
        ));
  }

  Widget _trendingDescription() {
    Game _game = Common.allGamesList[_trendingDecriptionIndex];
    return MeasureSize(
        onChange: (size) {
          setState(() {
            myChildSize = size;
          });
        },
        child: GameBody(
          game: _game,
          index: 0, //TODO actual index
          isDescription: false,
          onPressedPrimary: () => _onPressedPrimary(_game),
        ));
  }
}