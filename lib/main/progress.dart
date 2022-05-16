import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../custom_widgets/custom_scaffold.dart';
import '../custom_widgets/style.dart';
import '../main.dart';
import 'common.dart';
import '../custom_widgets/custom_colors.dart';

class Progress extends StatefulWidget {
  const Progress({Key? key}) : super(key: key);

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  double _width = 200;
  double _height = 200;

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.redColor.shade900;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        name: "Progress",
        leadingIcon: Icons.home,
        leadingName: "Menu",
        leadingScreen: Activity.Menu,
        leadingTarget: const MainMenu(),
        hasFloating: false,
        body: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 400,
            child: Row(children: [
              //2eme
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: 100,
                    width: _width,
                  ),
                  Container(
                    child: SizedBox(
                        height: 100,
                        width: _width,
                        child: Center(
                            child: Text(
                          Common.allGamesList[3].name,
                          style: GoogleFonts.fredokaOne(
                              fontSize: 16,
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  offset: Offset(3, 3),
                                )
                              ]),
                        ))),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.network(
                                  Common.allGamesList[3].backgroundImage)
                              .image,
                          fit: BoxFit.fitHeight),
                    ),
                  ),
                  Container(
                    color: Colors.deepPurple.shade500,
                    width: _width,
                    child: const Center(child: Text('2ème')),
                  ),
                  Expanded(
                      child: Container(
                          color: Color.fromRGBO(0xFF, 0x7B, 0x7B, 1),
                          height: _height,
                          width: _width,
                          child: const Center(child: Text('Time played 20h')))),
                ],
              ),
              //1er
              Column(
                children: [
                  Container(
                    child: SizedBox(
                        height: 100,
                        width: _width,
                        child: Center(
                            child: Text(
                          Common.allGamesList[1].name,
                          style: GoogleFonts.fredokaOne(
                              fontSize: 16,
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  offset: Offset(3, 3),
                                )
                              ]),
                        ))),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.network(
                                  Common.allGamesList[1].backgroundImage)
                              .image,
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                  Container(
                    color: Colors.deepPurple.shade400,
                    width: _width,
                    child: const Center(child: Text('1er')),
                  ),
                  Expanded(
                      child: Container(
                          width: _width,
                          color: Color.fromRGBO(0xFF, 0x52, 0x52, 1),
                          child: const Center(child: Text('Time played 30h'))))
                ],
              ),
              //3eme
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: 200,
                    width: _width,
                  ),
                  Container(
                    child: SizedBox(
                        height: 100,
                        width: _width,
                        child: Center(
                            child: Text(
                          Common.allGamesList[2].name,
                          style: GoogleFonts.fredokaOne(
                              fontSize: 16,
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  offset: Offset(3, 3),
                                )
                              ]),
                        ))),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.network(
                                  Common.allGamesList[2].backgroundImage)
                              .image,
                          fit: BoxFit.fitHeight),
                    ),
                  ),
                  Container(
                    color: Colors.deepPurple.shade300,
                    width: _width,
                    child: const Center(child: Text('3ème')),
                  ),
                  Expanded(
                      child: Container(
                          color: Color.fromRGBO(0xFF, 0x7B, 0x7B, 1),
                          width: _width,
                          child: const Center(child: Text('Time played 10h'))))
                ],
              )
            ]),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 400,
            child: Row(children: [
              //2eme
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: 100,
                    width: _width,
                  ),
                  Container(
                    child: SizedBox(
                        height: 100,
                        width: _width,
                        child: Center(
                            child: Text(
                          Common.allGamesList[3].name,
                          style: GoogleFonts.fredokaOne(
                              fontSize: 16,
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  offset: Offset(3, 3),
                                )
                              ]),
                        ))),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.network(
                                  Common.allGamesList[3].backgroundImage)
                              .image,
                          fit: BoxFit.fitHeight),
                    ),
                  ),
                  Container(
                    color: Colors.deepPurple.shade500,
                    width: _width,
                    child: const Center(child: Text('2ème')),
                  ),
                  Expanded(
                      child: Container(
                          color: Color.fromRGBO(0xFF, 0x7B, 0x7B, 1),
                          height: _height,
                          width: _width,
                          child: const Center(
                              child: Text('Successes completed: 62%')))),
                ],
              ),
              //1er
              Column(
                children: [
                  Container(
                    child: SizedBox(
                        height: 100,
                        width: _width,
                        child: Center(
                            child: Text(
                          Common.allGamesList[1].name,
                          style: GoogleFonts.fredokaOne(
                              fontSize: 16,
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  offset: Offset(3, 3),
                                )
                              ]),
                        ))),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.network(
                                  Common.allGamesList[1].backgroundImage)
                              .image,
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                  Container(
                    color: Colors.deepPurple.shade400,
                    width: _width,
                    child: const Center(child: Text('1er')),
                  ),
                  Expanded(
                      child: Container(
                          width: _width,
                          color: Color.fromRGBO(0xFF, 0x52, 0x52, 1),
                          child: const Center(
                              child: Text('Successes completed: 87%'))))
                ],
              ),
              //3eme
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: 200,
                    width: _width,
                  ),
                  Container(
                    child: SizedBox(
                        height: 100,
                        width: _width,
                        child: Center(
                            child: Text(
                          Common.allGamesList[2].name,
                          style: GoogleFonts.fredokaOne(
                              fontSize: 16,
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  offset: Offset(3, 3),
                                )
                              ]),
                        ))),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.network(
                                  Common.allGamesList[2].backgroundImage)
                              .image,
                          fit: BoxFit.fitHeight),
                    ),
                  ),
                  Container(
                    color: Colors.deepPurple.shade300,
                    width: _width,
                    child: const Center(child: Text('3ème')),
                  ),
                  Expanded(
                      child: Container(
                          color: Color.fromRGBO(0xFF, 0x7B, 0x7B, 1),
                          width: _width,
                          child: const Center(
                              child: Text('Successes completed: 45%'))))
                ],
              )
            ]),
          ),
        ]));
  }
}
