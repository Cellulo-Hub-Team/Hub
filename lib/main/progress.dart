import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../custom_widgets/custom_scaffold.dart';
import '../custom_widgets/style.dart';
import '../game/game.dart';
import '../main.dart';
import 'common.dart';
import '../custom_widgets/custom_colors.dart';

class Progress extends StatefulWidget {
  const Progress({Key? key}) : super(key: key);

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  double _width = 0;
  double _height = 200;

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.redColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _width = min(MediaQuery.of(context).size.width, 1000) / 4;
    return CustomScaffold(
        name: "Progress",
        leadingIcon: Icons.home,
        leadingName: "Menu",
        leadingScreen: Activity.Menu,
        leadingTarget: const MainMenu(),
        hasFloating: false,
        body: SingleChildScrollView(
            child: Center(
                child: Container(
                  padding: const EdgeInsets.all(50),
          width: MediaQuery.of(context).size.width,
          height: 500,
          child: Row(children: [
            const Spacer(),
            //2nd
            _podiumStep(100, 0, Common.allGamesList[0]),
            //1st
            _podiumStep(0, 1, Common.allGamesList[1]),
            //3rd
            _podiumStep(200, 2, Common.allGamesList[2]),
            const Spacer(),
          ]),
        ))));
  }

  Widget _podiumStep(double _offset, int _index, Game _game) {
    return Column(
      children: [
        Container(
          height: _offset,
          width: _width,
        ),
        Container(
          child: SizedBox(
              height: 100,
              width: _width,
              child: Center(
                  child: Text(
                _game.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.fredokaOne(
                    fontSize: 32,
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
        Container(
          color: Color.fromRGBO(0xFF, 0x40, 0x40, 1),
          width: _width,
          height: 30,
          child: _index == 1
              ? const Icon(MaterialCommunityIcons.medal, size: 28, color: Colors.white)
              : Center(child: Text(_index == 0 ? '2nd' : '3rd', style: TextStyle(color: Colors.white))),
        ),
        Expanded(
            child: Container(
                decoration: BoxDecoration(
                  gradient: _index != 1 ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      _index < 1 ? Color.fromRGBO(0xFF, 0x70, 0x70, 1) : Color.fromRGBO(0xFF, 0x50, 0x50, 1),
                      _index > 1 ? Color.fromRGBO(0xFF, 0x70, 0x70, 1) : Color.fromRGBO(0xFF, 0x50, 0x50, 1),
                    ],
                  ) : null,
                  color: _index == 1 ? Color.fromRGBO(0xFF, 0x68, 0x68, 1) : null,
                ),
                height: _height,
                width: _width,
                child: const Center(child: Text('Time played : 20h', style: TextStyle(color: Colors.white, fontSize: 15))))),
      ],
    );
  }
}
