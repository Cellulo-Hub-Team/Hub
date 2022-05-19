import 'dart:convert';
import 'dart:io';

import 'package:cellulo_hub/custom_widgets/custom_scaffold.dart';
import 'package:cellulo_hub/game/game_body.dart';
import 'package:cellulo_hub/game/game_header.dart';
import 'package:cellulo_hub/main/my_games.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../custom_widgets/custom_colors.dart';
import '../custom_widgets/custom_delegate.dart';
import '../custom_widgets/style.dart';
import '../main/achievement.dart';
import '../main/common.dart';
import '../main/shop.dart';
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
  final List<TableRow> _achievementsTable = [];
  int _minutes = 3;

  _getAchievements() async {
    String? _user = Platform.environment['USERPROFILE']?.replaceAll(r"\", "/");
    var path = _user! +
        "/AppData/LocalLow/" +
        widget.game.unityCompanyName +
        "/" +
        widget.game.unityName +
        "/achievements.json";
    int _index = 0;
    int _count = 0;
    if (!await File(path).exists()) {
      return;
    }
    await File(path)
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
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
      _achievementsTable.add(_achievementRow(
          _achievement.label,
          MaterialCommunityIcons.medal,
          _achievement.value > 0
              ? Icon(Feather.check_square,
                  size: 40, color: CustomColors.darkThemeColor())
              : Icon(Feather.square,
                  size: 40, color: CustomColors.darkThemeColor())));
      return;
    }
    if (_achievement.type == "multiple") {
      _achievementsTable.add(_achievementRow(
          _achievement.label,
          MaterialCommunityIcons.counter,
          _achievement.value >= _achievement.steps
              ? Icon(Feather.check_square,
                  size: 40, color: CustomColors.darkThemeColor())
              : Text("${_achievement.value} / ${_achievement.steps}",
                  style: Style.achievementStyle())));
      return;
    }
    _achievementsTable.add(_achievementRow(
        _achievement.label,
        Ionicons.ios_podium,
        Text(_achievement.value.toString(), style: Style.achievementStyle())));
  }

  @override
  void initState() {
    Common.percentageController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    Common.percentageController.reset();
    Common.percentageController.forward();
    _getAchievements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      name: widget.game.name,
      leadingIcon: Icons.arrow_back,
      leadingName: "Back",
      leadingScreen: Common.currentScreen,
      leadingTarget: Common.currentScreen == Activity.MyGames
          ? const MyGames()
          : const Shop(),
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
                              child:
                                  Text("Achievements", style: Style.tabStyle()),
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
              child: Text(
                  widget.game.celluloCount.toString() + " cellulos required.",
                  style: Style.descriptionStyle())),
          Padding(
              padding:
              const EdgeInsets.all(15), //apply padding to all four sides
              child: Text(
                  _minutes.toString() + " minutes played.",
                  style: Style.descriptionStyle())),
          Padding(
              padding:
                  const EdgeInsets.all(15), //apply padding to all four sides
              child: Text(widget.game.instructions,
                  style: Style.descriptionStyle()))
        ]));
  }

  Widget _achievementsPanel() {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Table(
          border: TableBorder(
              horizontalInside: BorderSide(
                  width: 1,
                  color: CustomColors.darkThemeColor(),
                  style: BorderStyle.solid),
              verticalInside: BorderSide(
                  width: 1,
                  color: CustomColors.darkThemeColor(),
                  style: BorderStyle.solid)),
          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(100),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(200),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: _achievementsTable,
        ));
  }

  TableRow _achievementRow(String _label, IconData _icon, Widget _value) {
    return TableRow(
      children: <Widget>[
        SizedBox(
            height: 100,
            child: Icon(_icon, size: 40, color: CustomColors.darkThemeColor())),
        TableCell(
          child: Center(child: Text(_label, style: Style.descriptionStyle())),
        ),
        TableCell(
          child: Center(child: _value),
        ),
      ],
    );
  }
}
