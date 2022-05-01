import 'package:cellulo_hub/game/game_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/game.dart';
import '../main/common.dart';

class CustomTextButton extends StatefulWidget {
  final Game game;
  final bool inMyGames;
  const CustomTextButton({Key? key,
    required this.game,
    required this.inMyGames})
      : super(key: key);

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => Common.goToTarget(context, GameDescription(game: widget.game, inMyGames: widget.inMyGames), true, Common.currentScreen),
        onHover: (isHovered) => setState(() {
          _isHovered = isHovered;
        }),
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)),
        child: Row(children: [
          Text("See more ",
              style: GoogleFonts.comfortaa(
                  color: _isHovered ? Colors.grey : Colors.grey.shade700,
                  fontSize: 20)),
          Icon(Feather.arrow_right_circle,
              color: _isHovered ? Colors.grey : Colors.grey.shade700, size: 15),
        ]));
  }

  _onPressed(Widget _target) {
    Navigator.push(
      context,
      PageRouteBuilder(
          pageBuilder: (_, __, ___) => _target,
          transitionDuration: const Duration(seconds: 0)),
    );
  }
}
