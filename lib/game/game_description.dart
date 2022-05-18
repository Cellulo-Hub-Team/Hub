import 'dart:convert';
import 'dart:io';

import 'package:cellulo_hub/custom_widgets/custom_scaffold.dart';
import 'package:cellulo_hub/game/game_body.dart';
import 'package:cellulo_hub/game/game_header.dart';
import 'package:cellulo_hub/main/my_games.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../custom_widgets/custom_colors.dart';
import '../custom_widgets/custom_delegate.dart';
import '../main.dart';
import '../main/achievement.dart';
import '../main/common.dart';
import '../main/shop.dart';
import '../custom_widgets/style.dart';
import 'game.dart';

class GameDescription extends StatefulWidget {
  final Game game;
  final int index;
  final VoidCallback? onPressedPrimary;
  final VoidCallback? onPressedSecondary;
  final VoidCallback? onPressedTertiary;
  const GameDescription({
    Key? key,
    required this.game,
    required this.index,
    this.onPressedPrimary,
    this.onPressedSecondary,
    this.onPressedTertiary,
  }) : super(key: key);

  @override
  State<GameDescription> createState() => _GameDescriptionState();
}

class _GameDescriptionState extends State<GameDescription>
    with TickerProviderStateMixin {
  List<Widget> _achievementsWidgets = [];

  _getAchievements() async {
    String? _user = Platform.environment['USERPROFILE']?.replaceAll(r"\", "/");
    print(_user! +
        "/AppData/LocalLow/" +
        widget.game.unityCompanyName +
        "/" +
        widget.game.unityName +
        "/achievements.json");
    var path = _user + "/AppData/LocalLow/Chili/Achievements/achievements.json";
    int _index = 0;
    int _count = 0;
    int _minutes = 0;
    if (!await File(path).exists()) {
      return;
    }
    await File(path)
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .forEach((line) {
      if (_index == 0) {
        _count = int.parse(line);
        _index++;
        return;
      }
      if (_index == _count + 1) {
        _minutes = int.parse(line);
        print("Time played: $_minutes minutes");
        return;
      }
      Map<String, dynamic> achievementMap = jsonDecode(line);
      _buildAchievement(Achievement.fromJson(achievementMap));
      _index++;
    });
  }

  _buildAchievement(Achievement _achievement) {
    if (_achievement.type == "one") {
      _achievementsWidgets.add(Text(_achievement.label +
          ((_achievement.value > 0) ? ": Completed" : ": Not completed")));
      return;
    }
    if (_achievement.type == "multiple") {
      _achievementsWidgets.add(Text(_achievement.label +
          "${_achievement.value} / ${_achievement.steps}"));
      return;
    }
    _achievementsWidgets
        .add(Text(_achievement.label + ": Highest = ${_achievement.value}"));
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
    return CustomScaffold(
      name: widget.game.name,
      leadingIcon: Icons.arrow_back,
      leadingName: "Back",
      leadingScreen: Common.currentScreen,
      leadingTarget:
          Common.currentScreen == Activity.MyGames ? MyGames() : Shop(),
      hasFloating: false,
      body: DefaultTabController(
        length: 3,
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
                      SliverAppBar(
                          collapsedHeight: 150,
                          expandedHeight: 150,
                          backgroundColor:
                              CustomColors.inversedDarkThemeColor(),
                          automaticallyImplyLeading: false,
                          leading: null,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Hero(
                                tag: 'game' + widget.index.toString(),
                                child: GameHeader(game: widget.game)),
                          )),
                      SliverPersistentHeader(
                        delegate: CustomDelegate(TabBar(
                          tabs: [
                            Tab(
                                icon: const Icon(FontAwesome.gamepad),
                                child: Text("Description",
                                    style: Style.tabStyle())),
                            Tab(
                              icon: const Icon(
                                  MaterialCommunityIcons.hexagon_slice_6),
                              child:
                                  Text("Installation", style: Style.tabStyle()),
                            ),
                            Tab(
                              icon: const Icon(Ionicons.md_podium),
                              child: Text("Successes", style: Style.tabStyle()),
                            ),
                          ],
                          labelColor: CustomColors.currentColor,
                          indicatorColor: CustomColors.currentColor,
                          unselectedLabelColor: CustomColors.darkThemeColor(),
                        )),
                        floating: true,
                        pinned: true,
                      )
                    ];
                  },
                  body: TabBarView(
                    children: [
                      GameBody(
                        game: widget.game,
                        index: widget.index,
                        isDescription: true,
                        onPressedPrimary: widget.onPressedPrimary,
                        onPressedSecondary: widget.onPressedSecondary,
                        onPressedTertiary: widget.onPressedTertiary,
                      ),
                      _instructions(),
                      _achievementsPanel(),
                    ],
                  ),
                ))),
      ),
    );
  }

  Widget _instructions() {
    return Container(
        width: 500,
        alignment: Alignment.center,
        child: Column(children: [
          Padding(
              padding:
                  const EdgeInsets.all(15), //apply padding to all four sides
              child: Text("Installation instructions",
                  style: Style.descriptionStyle())),
          Padding(
              padding:
                  const EdgeInsets.all(15), //apply padding to all four sides
              child: Text(
                  widget.game.celluloCount.toString() + " cellulos required.",
                  style: Style.descriptionStyle())),
          Padding(
              padding:
                  const EdgeInsets.all(15), //apply padding to all four sides
              child: Text(widget.game.instructions,
                  style: Style.descriptionStyle()))
        ]));
  }

  Widget _achievementsPanel() {
    return Container(
        width: 500,
        alignment: Alignment.center,
        child: Column(children: _achievementsWidgets));
  }
}
