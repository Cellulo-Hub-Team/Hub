import 'package:cellulo_hub/main/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../custom_widgets/custom_icon_button.dart';
import '../custom_widgets/style.dart';
import 'game.dart';

//The top constant part of the game panel
class GameHeader extends StatefulWidget {
  final Game game;
  const GameHeader({Key? key, required this.game}) : super(key: key);

  @override
  State<GameHeader> createState() => _GameHeaderState();
}

class _GameHeaderState extends State<GameHeader> {
  static const double _height = 150;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: SizedBox(
              height: _height,
              child: Center(
                  child: Text(
                widget.game.name,
                style: Style.bannerStyle(),
              ))),
          decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: widget.game.isInstalled ||
                        widget.game.webUrl != null ||
                        Common.currentScreen != Activity.MyGames
                    ? null
                    : ColorFilter.mode(
                        Colors.black.withOpacity(.8), BlendMode.darken),
                image: Image.network(widget.game.backgroundImage).image,
                fit: BoxFit.fitWidth),
          ),
        ),
        widget.game.isExpanded
            ? SizedBox(
                height: _height,
                child: Row(mainAxisSize: MainAxisSize.max, children: [
                  Column(
                    children: [
                      Spacer(),
                      CustomIconButton(
                          label: "Web",
                          icon: MaterialCommunityIcons.web,
                          color: widget.game.webUrl != null
                              ? Colors.lightBlueAccent
                              : Colors.grey.shade800,
                          onPressed: () => Common.showSnackBar(
                              context,
                              "This game is" +
                                  (widget.game.webUrl != null ? " " : " not ") +
                                  "available on Web")),
                      Spacer(),
                      CustomIconButton(
                          label: "Android",
                          icon: FontAwesome.android,
                          color: widget.game.androidBuild != null
                              ? Colors.greenAccent
                              : Colors.grey.shade800,
                          onPressed: () => Common.showSnackBar(
                              context,
                              "This game is" +
                                  (widget.game.androidBuild != null
                                      ? " "
                                      : " not ") +
                                  "available on Android")),
                      Spacer(),
                      CustomIconButton(
                          label: "iOS",
                          icon: FontAwesome.apple,
                          color: widget.game.iOSBuild != null
                              ? Colors.grey
                              : Colors.grey.shade800,
                          onPressed: () => Common.showSnackBar(
                              context,
                              "This game is" +
                                  (widget.game.iOSBuild != null
                                      ? " "
                                      : " not ") +
                                  "available on iOS")),
                      Spacer(),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Spacer(),
                      CustomIconButton(
                          label: "Windows",
                          icon: MaterialCommunityIcons.windows,
                          color: widget.game.windowsBuild != null
                              ? Colors.blue
                              : Colors.grey.shade800,
                          onPressed: () => Common.showSnackBar(
                              context,
                              "This game is" +
                                  (widget.game.windowsBuild != null
                                      ? " "
                                      : " not ") +
                                  "available on Windows")),
                      Spacer(),
                      CustomIconButton(
                          label: "Linux",
                          icon: MaterialCommunityIcons.linux,
                          color: widget.game.linuxBuild != null
                              ? Colors.amber
                              : Colors.grey.shade800,
                          onPressed: () => Common.showSnackBar(
                              context,
                              "This game is" +
                                  (widget.game.linuxBuild != null
                                      ? " "
                                      : " not ") +
                                  "available on Linux")),
                      Spacer(),
                      CustomIconButton(
                          label: "MacOS",
                          icon: FontAwesome.apple,
                          color: widget.game.macOSBuild != null
                              ? Colors.grey
                              : Colors.grey.shade800,
                          onPressed: () => Common.showSnackBar(
                              context,
                              "This game is" +
                                  (widget.game.macOSBuild != null
                                      ? " "
                                      : " not ") +
                                  "available on MacOS")),
                      Spacer(),
                    ],
                  ),
                ]))
            : ((widget.game.webUrl != null ||
                    Common.canBeInstalledOnThisPlatform(widget.game))
                ? Container()
                : SizedBox(
                    height: 150,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: _unavailableTag(context))))
      ],
    );
  }

  Widget _unavailableTag(BuildContext _context) {
    return ElevatedButton.icon(
      onPressed: () => Common.showSnackBar(
          _context, "This game is not available on this platform"),
      icon: const Icon(
        FontAwesome.warning,
        color: Colors.white,
      ),
      label: Text(
        'Unavailable on your device',
        style:
            GoogleFonts.comfortaa(fontSize: 14, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.blueGrey,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        fixedSize: const Size(170, 50),
      ),
    );
  }
}
