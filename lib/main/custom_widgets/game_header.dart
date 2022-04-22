import 'package:cellulo_hub/main/custom_widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:cellulo_hub/main/common.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../game.dart';
import '../style.dart';

class GameHeader extends StatefulWidget {
  final Game game;
  final bool inMyGames;
  const GameHeader({Key? key,
    required this.game,
    required this.inMyGames}) : super(key: key);

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
                    style: Style.gameStyle(),
                  ))),
          decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter:
                widget.game.isInstalled || widget.game.webUrl != null || !widget.inMyGames
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
          child: Column(
            children: [
              CustomIconButton(
                  label: "Android",
                  icon: FontAwesome.android,
                  color: Colors.greenAccent,
                  onPressed: () => Common.showSnackBar(context,
                      "This game is" + (widget.game.androidBuild != null ? " " : "") + "available on Android")),
              CustomIconButton(
                label: "Linux",
                icon: FontAwesome.android,
                color: Colors.amber,
                  onPressed: () => Common.showSnackBar(context,
                      "This game is" + (widget.game.linuxBuild != null ? " " : "") + "available on Linux")),
              CustomIconButton(
                  label: "Web",
                  icon: FontAwesome.android,
                  color: Colors.lightBlueAccent,
                  onPressed: () => Common.showSnackBar(context,
                      "This game is" + (widget.game.webUrl != null ? " " : "") + "available on Web")),
            ],
          ),
        )
            : ((widget.game.webUrl != "" || Common.canBeInstalledOnThisPlatform(widget.game))
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
      onPressed: () =>
          Common.showSnackBar(_context, "This game is not available on this platform"),
      icon: const Icon(
        FontAwesome.warning,
        color: Colors.white,
      ),
      label: Text(
        'Not available on your device',
        style: Style.tagStyle(true, true),
        textAlign: TextAlign.center,
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.blueGrey,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        fixedSize: const Size(180, 50),
      ),
    );
  }
}