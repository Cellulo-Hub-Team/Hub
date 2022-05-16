import 'dart:math';

import 'package:cellulo_hub/custom_widgets/colored_app_bar.dart';
import 'package:cellulo_hub/main.dart';
import 'package:cellulo_hub/main/search_result.dart';
import 'package:device_apps/device_apps.dart';
import 'package:cellulo_hub/custom_widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../api/flutterfire_api.dart';
import '../api/firedart_api.dart';
import '../custom_widgets/custom_delegate.dart';
import '../custom_widgets/custom_elevated_button.dart';
import '../custom_widgets/custom_scaffold.dart';
import '../game/game_body.dart';
import '../game/game_description.dart';
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

class _ShopState extends State<Shop> with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _trendingDescriptionDisplayed = false;
  String _searchResult = "";
  late Game? _beingInstalledGame;


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

  final List<Game> _trendingGames = List.from(Common.allGamesList)..sort((a,b) => b.downloads.compareTo(a.downloads));


  ///Function called when pressing Add to My Games button
  _onPressedPrimary(Game _game) async {
      if (_game.isInLibrary) {
        Common.goToTarget(context, const MyGames(), false, Activity.MyGames);
      } else {
        setState(() {
          _game.isInLibrary = true;
        });
        Common.isDesktop ? await FiredartApi.addToUserLibrary(_game) : await FlutterfireApi.addToUserLibrary(_game);
        Common.showSnackBar(context, "Correctly added to My Games!");
        _beingInstalledGame = _game;
        if (Common.isAndroid){
          await FlutterfireApi.downloadFile(_game);
        }
        Common.isDesktop ? await FiredartApi.incrementDownloads(_game) : await FlutterfireApi.incrementDownloads(_game);
      }
  }

  ///Function called when pressing search icon
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
                  SearchResult(
                      selectedGames: _selectedGames,
                      onPressedPrimary: _onPressedPrimary,
                  )),
        );
      }
    });
  }

  ///Function called when pressing a trending game thumbnail
  _onPressedTrending(int _index) {
    setState(() {
      if (_trendingDescriptionDisplayed && _index == _trendingDecriptionIndex) {
        _trendingController.reverse();
        Future.delayed(
            const Duration(milliseconds: 300),
                () => _trendingDescriptionDisplayed = !_trendingDescriptionDisplayed);
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
    CustomColors.currentColor = CustomColors.blueColor();
    WidgetsBinding.instance?.addObserver(this);
    Common.percentageController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _trendingController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    Common.percentageController.reset();
    Common.percentageController.forward();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _beingInstalledGame != null) {
      if (await DeviceApps.isAppInstalled(FlutterfireApi.createPackageName(_beingInstalledGame!))) {
        setState(() {
          _beingInstalledGame!.isInstalled = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      name: "Shop",
      leadingIcon: Icons.home,
      leadingName: "Menu",
      leadingScreen: Activity.Menu,
      leadingTarget: const MainMenu(),
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
                  physics: Common.isWeb || Common.isWindows
                      ? const ClampingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  headerSliverBuilder: (context, value) {
                    return [
                      AnimatedBuilder(
                          animation: _trendingController,
                          builder: (BuildContext context, Widget? child) {
                            return SliverAppBar(
                                backgroundColor: CustomColors.inversedDarkThemeColor(),
                                automaticallyImplyLeading: false,
                                leading: null,
                                collapsedHeight: 420, // Check for web and desktop
                                expandedHeight: (_trendingController
                                            .drive(
                                                CurveTween(curve: Curves.ease))
                                            .value *
                                        (myChildSize.height + 30)) +
                                    420,
                                flexibleSpace: FlexibleSpaceBar(
                                    background: Column(children: [
                                      const SizedBox(height: 10),
                                      Text("Trending", style: Style.titleStyle()),
                                  _trendingWidget(),
                                  _trendingDescriptionDisplayed
                                      ? (Common.isDesktop || Common.isWeb || MediaQuery.of(context).orientation == Orientation.landscape
                                        ? _trendingDescriptionDesktop()
                                        : _trendingDescription())
                                      : Container(),
                                      Padding(
                                          padding: const EdgeInsets.only(left: 100, right: 100, top: 10, bottom: 10),
                                        child: Container(height: 2, color: Colors.grey.shade200, child: Container()),
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
                            unselectedLabelColor: CustomColors.darkThemeColor(),
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

  ///Trending games list
  Widget _trendingWidget() {
    return SizedBox(
        height: 270,
        child: ScrollSnapList(
          itemBuilder: _buildItemTrendingList,
          itemSize: 250,
          dynamicItemSize: true,
          onReachEnd: () {},
          itemCount: 3,
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

  ///Builder for each game in the trending list
  Widget _buildItemTrendingList(BuildContext context, int index) {
    return Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Container(
          width: 250,
          child: TextButton(
            onPressed: () => _onPressedTrending(index),
            child: Text(
              _trendingGames[index].name,
              textAlign: TextAlign.center,
              style: Style.bannerStyle(),
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                  image:
                      Image.network(_trendingGames[index].backgroundImage)
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
    Game _game = _trendingGames[_trendingDecriptionIndex];
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

  Widget _trendingDescriptionDesktop(){
    Game _game = _trendingGames[_trendingDecriptionIndex];
    return MeasureSize(
        onChange: (size) {
          setState(() {
            myChildSize = size;
          });
        },
        child:
        Container(
            width: 500,
            alignment: Alignment.center,
            child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(15), //apply padding to all four sides
                      child: Text(_game.description, style: Style.descriptionStyle())),
        Padding(
            padding: const EdgeInsets.all(15), //apply padding to all four sides
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 5),
                CustomElevatedButton(
                    label: _game.isInLibrary ? "See in library" : "Add to My Games",
                    onPressed: () => _onPressedPrimary(_game)),
                const Spacer(),
                CustomElevatedButton(
                    label: "See more",
                    onPressed: () => Common.goToTarget(
                        context,
                        GameDescription(
                          game: _game,
                          index: 0, //TODO actual index
                          onPressedPrimary: () => _onPressedPrimary(_game),
                        ),
                        false,
                        Common.currentScreen
                    )),
                const Spacer(flex: 5),
              ],
            ))
        ]))
    );

  }


  //Clean up this mess
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
