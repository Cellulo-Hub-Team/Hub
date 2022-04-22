import 'package:cellulo_hub/main/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'common.dart';
import 'game.dart';

class GameDescription extends StatefulWidget {
  final Game game;
  const GameDescription({Key? key, required this.game}) : super(key: key);

  @override
  State<GameDescription> createState() => _GameDescriptionState();
}

class _GameDescriptionState extends State<GameDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Common.appBar(context, widget.game.name, Icon(FontAwesome.gamepad)),
    body: Column(children: [
      gameHeaderBuilder(Common.allGamesList, 0, true, context),
      gameBody(widget.game, true),
      RichText(text: TextSpan(
        children: <TextSpan>[
          TextSpan(text: 'PLANNING POLYJAPAN TV\n\n', style: TextStyle(color: Colors.black, fontSize: 30)),
          TextSpan(text: '18 février 2022\n\n', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
          TextSpan(text: "Voilà le planning de l'émission spéciale PolyJapan TV de demain ! "
              "Vous aurez notamment l'occasion de participer à nos jeux concours. "
              "Parmi les lots à gagner, un dessin fait en live par l'artiste de notre affiche, "
              "Mystimily, ainsi que des billets pour Japan Impact 2022 ! "
              "Rendez-vous donc le 19 février à 13h pour cette émission de folie ! ",
              style: TextStyle(color: Colors.black)),
        ],
      ))
    ]));
  }
}
