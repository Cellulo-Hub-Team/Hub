import 'dart:io';
import 'package:cellulo_hub/api/shell_scripts.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:device_apps/device_apps.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firedart/firedart.dart';
import '../main/common.dart';
import '../game/game.dart';

//TODO: Trouver un moyen clean de faire une ref static/ Exceptions/ Link à firebase storage quand on aura les jeux

class FiredartApi {
  static Future<Directory> appDocDir = getApplicationDocumentsDirectory();
  static FirebaseAuth auth = FirebaseAuth.instance;
  static CollectionReference games = Firestore.instance.collection('games');
  static CollectionReference owns = Firestore.instance.collection('owns');
  static const String nameUnity = 'Game Name Unity',
      companyName = 'Company Name',
      companyNameUnity = 'Company Name Unity',
      gameDescription = 'Game Description',
      gameInstructions = 'Game Instructions',
      webBuild =  'Web Build',
      webLink = 'Web Link',
      linuxBuild = 'Linux Build',
      androidBuild = 'Android Build',
      windowsBuild = 'Windows Build',
      backgroundImage = 'Background Image',
      physicalPercentage = 'Physical Percentage',
      cognitivePercentage = 'Cognitive Percentage',
      socialPercentage = 'Social Percentage',
      celluloCount = 'Cellulo Count',
      downloads = 'Downloads';

  //Creates local list of all games available in the shop
  static Future<void> buildAllGamesList() async {
    var allGamesFuture = await games.get();
    final allGames = allGamesFuture.toList();
    for (var game in allGames) {
      String? androidUrl = game["Android Build"] == "" ? null : game["Android Build"];
      String? linuxUrl = game["Linux Build"] == "" ? null : game["Linux Build"];
      String? windowsUrl = game["Windows Build"] == "" ? null : game["Windows Build"];
      String? webUrl = game["Web Link"] == "" ? null : game["Web Link"];

      Game _toAdd = Game(
          game.id,
          game[nameUnity],
          game[companyName],
          game[companyNameUnity],
          game[gameDescription],
          game[gameInstructions],
          game[backgroundImage],
          androidUrl,
          linuxUrl,
          windowsUrl,
          webUrl,
          game[physicalPercentage],
          game[cognitivePercentage],
          game[socialPercentage],
          game[celluloCount],
          game[downloads]
      );
      _toAdd.isInstalled = await ShellScripts.isInstalledGameWindows(_toAdd);
      Common.allGamesList.add(_toAdd);
    }
  }

  //Creates the local list of games the player owns
  static Future<void> buildUserGamesList() async {
    var allGamesFuture = await owns.get();
    final allGames = allGamesFuture.toList();
    var user = await auth.getUser();
    for (var game in allGames) {
      if (game["User Uid"] == user.id) {
        for (var localGame in Common.allGamesList) {
          if (localGame.name == game["Game Uid"]) {
            localGame.isInLibrary = true;
          }
        }
      }
    }
  }

  //Add game to user library on the database
  static Future<void> addToUserLibrary(Game game) async {
    var user = await auth.getUser();
    return owns
        .document(UniqueKey().toString())
        .set({'Game Uid': game.name, 'User Uid': user.id})
        .then((value) => print("Game added to user library"))
        .catchError(
            (error) => print("Failed to add game to user library: $error"));
  }


  //Launches url corresponding to the web version of the game
  static void launchWebApp(Game game) async {
    String? url = game.webUrl;
    if (await canLaunch(url!)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ///Basic Email+password signUp (found on FirebaseAuth doc)
  static Future<void> signUp(String email, String password) async {
    try {
      await FirebaseAuth.instance.signUp(email, password);
    } on Exception catch (e) {
      print(e);
    }
  }

  ///Basic Email+password signIn (found on FirebaseAuth doc)
  static Future<void> signIn(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signIn(email, password);
      //Now that user is logged in, we can build the list of games he owns
      await buildAllGamesList();
      await buildUserGamesList();
    } on Exception catch (e) {
      Common.showSnackBar(context, 'Wrong username or password.');
    }
  }

  ///Launches game (game)
  static void launchApp(Game game) async {
    if (game.isInstalled) {
      if (Common.isWindows) {
        ShellScripts.launchGameWindows(game);
      } //TODO Linux and Mac

    }
  }

  ///Generate the name of the package according to the game company and an optional name
  static String createPackageName(Game game, [String? name]) {
    return name == null
        ? ('com.${game.companyName}.${game.name}'
            .toLowerCase()
            .replaceAll(' ', ''))
        : ('com.${game.companyName}.$name'.toLowerCase());
  }

  ///Check if a user is logged in
  static bool isLoggedIn() {
    return auth.isSignedIn;
  }

  ///Get the current user, can be null
  static getUser() {
    return auth.getUser();
  }

/*static void getGames() async {
    QuerySnapshot<Object?> gameList = await games.get();
    final allData = gameList.docs.map((doc) => doc.data()).toList();
    gameList.docs.forEach((element) {
      element
      .
    })
    print(allData);
  }*/
}
