import 'package:cellulo_hub/custom_widgets/custom_scaffold.dart';
import 'package:cellulo_hub/game/game_body.dart';
import 'package:cellulo_hub/game/game_header.dart';
import 'package:cellulo_hub/main/my_games.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../custom_widgets/custom_colors.dart';
import '../custom_widgets/custom_delegate.dart';
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
  const GameDescription({Key? key,
    required this.game,
    required this.index,
    this.onPressedPrimary,
    this.onPressedSecondary,
    this.onPressedTertiary,
  })
      : super(key: key);

  @override
  State<GameDescription> createState() => _GameDescriptionState();
}

class _GameDescriptionState extends State<GameDescription> with TickerProviderStateMixin {

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
      leadingTarget: Common.currentScreen == Activity.MyGames ? MyGames() : Shop(),
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
                          backgroundColor: CustomColors.inversedDarkThemeColor(),
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
                      GameBody(game: widget.game,
                        index: widget.index,
                        isDescription: true,
                        onPressedPrimary: widget.onPressedPrimary,
                        onPressedSecondary: widget.onPressedSecondary,
                        onPressedTertiary: widget.onPressedTertiary,
                      ),
                      _instructions(),
                      _successes(),
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
              child: Text(widget.game.celluloCount.toString() + " cellulos required.",
                  style: Style.descriptionStyle())),
          Padding(
              padding:
                  const EdgeInsets.all(15), //apply padding to all four sides
              child: Text(
                  widget.game.instructions,
                  style: Style.descriptionStyle()))
        ]));
  }

  Widget _successes() {
    return Container(
        width: 500,
        alignment: Alignment.center,
        child: Column(children: [
          Padding(
              padding:
              const EdgeInsets.all(15), //apply padding to all four sides
              child: Text("Successes",
                  style: Style.descriptionStyle())),
          Padding(
              padding:
              const EdgeInsets.all(15), //apply padding to all four sides
              child: Text(
                  "Here are all the successes you unlocked for " + widget.game.name,
                  style: Style.descriptionStyle()))
        ]));
  }
}
