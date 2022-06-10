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

class _GameDescriptionState extends State<GameDescription> with TickerProviderStateMixin {
  final List<TableRow> _achievementsTable = [];

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
          MaterialCommunityIcons.medal,
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
    _achievementsTable.clear();
    for (var _achievement in Common.allAchievementsMap[widget.game] ?? []){
      _buildAchievement(_achievement);
    }
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
              child: Text(widget.game.instructions,
                  style: Style.descriptionStyle()))
        ]));
  }

  Widget _achievementsPanel() {
    return SizedBox(height: _achievementsTable.length * 130,child: SingleChildScrollView(child: Column(children: [
      Padding(
          padding:
          const EdgeInsets.all(15), //apply padding to all four sides
          child: Text(
              widget.game.minutesPlayed.toString() + " minutes played.",
              style: Style.descriptionStyle())),
      Table(
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
            0: FlexColumnWidth(.2),
            1: FlexColumnWidth(.6),
            2: FlexColumnWidth(.2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: _achievementsTable,
        )])));
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
