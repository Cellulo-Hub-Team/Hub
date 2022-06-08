import 'dart:async';

import 'package:cellulo_hub/api/shell_scripts.dart';
import 'package:cellulo_hub/custom_widgets/custom_elevated_button.dart';
import 'package:cellulo_hub/custom_widgets/custom_scaffold.dart';
import 'package:cellulo_hub/game/game_panel_list.dart';
import 'package:cellulo_hub/main.dart';
import 'package:cellulo_hub/main/shop.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/firedart_api.dart';
import '../api/flutterfire_api.dart';
import '../custom_widgets/custom_colors.dart';
import '../custom_widgets/style.dart';
import '../game/game.dart';
import 'achievement.dart';
import 'common.dart';

class MyAchievements extends StatefulWidget {
  const MyAchievements({Key? key}) : super(key: key);

  @override
  _MyAchievementsState createState() => _MyAchievementsState();
}

class _MyAchievementsState extends State<MyAchievements>
    with TickerProviderStateMixin, WidgetsBindingObserver {

  final List<TableRow> _achievementsTable = [];

  _buildAchievementsList(List<Pair> _sortedAchievements){
    _achievementsTable.clear();
    for (var _achievement in _sortedAchievements){
      _buildAchievement(_achievement);
    }
  }

  _buildAchievement(Pair _pair) {
    setState(() {
    if (_pair.achievement.type == "one") {
      _achievementsTable.add(_achievementRow(
          _pair.achievement.label,
          MaterialCommunityIcons.medal,
          _pair.achievement.value > 0
              ? Icon(Feather.check_square,
              size: 40, color: CustomColors.darkThemeColor())
              : Icon(Feather.square,
              size: 40, color: CustomColors.darkThemeColor()),
          _pair.game));
      return;
    }
    if (_pair.achievement.type == "multiple") {
      _achievementsTable.add(_achievementRow(
          _pair.achievement.label,
          MaterialCommunityIcons.medal,
          _pair.achievement.value >= _pair.achievement.steps
              ? Icon(Feather.check_square,
              size: 40, color: CustomColors.darkThemeColor())
              : Text("${_pair.achievement.value} / ${_pair.achievement.steps}",
              style: Style.achievementStyle()),
          _pair.game));
      return;
    }
    _achievementsTable.add(_achievementRow(
        _pair.achievement.label,
        Ionicons.ios_podium,
        Text(_pair.achievement.value.toString(), style: Style.achievementStyle()),
        _pair.game));
    });
  }

  _onPressedSort(int _sort){
      List<Pair> _achievementsList = [];
      for (var _game in Common.allGamesList){
        for (var _achievement in Common.allAchievementsMap[_game] ?? []){
          _achievementsList.add(Pair(_achievement, _game));
        }
      }
      switch(_sort){
        case 0: //Finished
          _achievementsList = _achievementsList.where((a) =>
          (a.achievement.type == "one" && a.achievement.value > 0)
              || (a.achievement.type == "multiple" && a.achievement.value == a.achievement.steps)
          ).toList();
          break;
        case 1: //Unfinished
          _achievementsList = _achievementsList.where((a) =>
          (a.achievement.type == "one" && a.achievement.value == 0)
              || (a.achievement.type == "multiple" && a.achievement.value < a.achievement.steps)
          ).toList();
          break;
        case 2: //Close to completion
          _achievementsList = _achievementsList.where((a) =>
          a.achievement.type == "multiple"
              && a.achievement.value < a.achievement.steps).toList();
          _achievementsList.sort((a, b) => a.achievement.value/a.achievement.steps < b.achievement.value/b.achievement.steps ? 1 : -1);
          break;
        case 3: //Far from completion
          _achievementsList = _achievementsList.where((a) => a.achievement.type == "multiple").toList();
          _achievementsList.sort((a, b) => a.achievement.value/a.achievement.steps > b.achievement.value/b.achievement.steps ? 1 : -1);
          break;
        case 4: //High scores
          _achievementsList = _achievementsList.where((a) => a.achievement.type == "high").toList();
          _achievementsList.sort((a, b) => a.achievement.value < b.achievement.value ? 1 : -1);
          break;
        case 5: //Close to completion
          _achievementsList = _achievementsList.where((a) => a.achievement.type == "high").toList();
          _achievementsList.sort((a, b) => a.achievement.value > b.achievement.value ? 1 : -1);
          break;
        default: break;
      }
      _buildAchievementsList(_achievementsList);
  }

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.redColor();
    _onPressedSort(6);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        name: "Achievements",
        leadingIcon: Icons.home,
        leadingName: "Menu",
        leadingScreen: Activity.Menu,
        leadingTarget: const MainMenu(),
        hasFloating: true,
        floatingIcon: Icons.filter_alt,
        floatingLabel: "Sort by",
        onPressedFloating: (){},
        drawer: Drawer(
          backgroundColor: CustomColors.inversedDarkThemeColor(),
            child:
                Column(children: [
                  const Spacer(flex: 2),
                  Text("Completion", style: TextStyle(fontSize: 20, color: CustomColors.darkThemeColor())),
                  const Spacer(),
                  CustomElevatedButton(label: "Show finished", onPressed: () => _onPressedSort(0)),
                  const Spacer(),
                  CustomElevatedButton(label: "Show unfinished", onPressed: () => _onPressedSort(1)),
                  const Spacer(),
                  CustomElevatedButton(label: "Show closest to completion", onPressed: () => _onPressedSort(2)),
                  const Spacer(),
                  CustomElevatedButton(label: "Show further to completion", onPressed: () => _onPressedSort(3)),
                  const Spacer(flex: 2),
                  Text("High scores", style: TextStyle(fontSize: 20, color: CustomColors.darkThemeColor())),
                  const Spacer(),
                  CustomElevatedButton(label: "Show highest", onPressed: () => _onPressedSort(4)),
                  const Spacer(),
                  CustomElevatedButton(label: "Show lowest", onPressed: () => _onPressedSort(5)),
                  const Spacer(flex: 5),

                ])
        ),
        body: SingleChildScrollView(child: Center(
            child: Container(
                width: 1000, alignment: Alignment.center, child:
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
                    0: FlexColumnWidth(.1),
                    1: FlexColumnWidth(.3),
                    2: FlexColumnWidth(.4),
                    3: FlexColumnWidth(.2),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: _achievementsTable,
                ))

            )));
  }

  TableRow _achievementRow(String _label, IconData _icon, Widget _value, Game _game) {
    return TableRow(
      children: <Widget>[
        SizedBox(
            child: Icon(_icon, size: 40, color: CustomColors.darkThemeColor())),
        Container(
          child: SizedBox(
              height: 100,
              child: Center(
                  child: Text(
                    _game.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredokaOne(
                        fontSize: 25,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            offset: Offset(3, 3),
                          )
                        ]),
                  ))),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.network(_game.backgroundImage).image,
                fit: BoxFit.cover),
          ),
        ),
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

class Pair<Achievement, Game> {
  final Achievement achievement;
  final Game game;

  Pair(this.achievement, this.game);
}
