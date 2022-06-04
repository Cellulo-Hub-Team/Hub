import 'dart:io';

import 'package:cellulo_hub/api/shell_scripts.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../game/game.dart';
import '../main/achievement.dart';
import '../main/common.dart';


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
      webBuild = 'Web Build',
      webLink = 'Web Link',
      linuxBuild = 'Linux Build',
      androidBuild = 'Android Build',
      windowsBuild = 'Windows Build',
      backgroundImage = 'Background Image',
      physicalPercentage = 'Physical Percentage',
      cognitivePercentage = 'Cognitive Percentage',
      socialPercentage = 'Social Percentage',
      celluloCount = 'Cellulo Count',
      downloads = 'Downloads',
      apk = 'apkName';

  ///Creates local list of all games available in the shop
  static Future<void> buildAllGamesList() async {
    var allGamesFuture = await games.get();
    final allGames = allGamesFuture.toList();
    for (var game in allGames) {
      String? androidUrl =
          game["Android Build"] == "" ? null : game["Android Build"];
      String? linuxUrl = game["Linux Build"] == "" ? null : game["Linux Build"];
      String? companyUrl = game["Company Link"] == "" ? null : game["Company Link"];
      String? windowsUrl =
          game["Windows Build"] == "" ? null : game["Windows Build"];
      String? webUrl = game["Web Link"] == "" ? null : game["Web Link"];

      Game _toAdd = Game(
          game.id,
          game[nameUnity],
          game[companyName],
          game[companyNameUnity],
          companyUrl,
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
          game[downloads],
          game[apk]);
      _toAdd.isInstalled = await ShellScripts.isInstalled(_toAdd);
      Common.allGamesList.add(_toAdd);
      Achievement.getAchievements(_toAdd);
    }
  }

  ///Creates the local list of games the player owns
  static Future<void> buildUserGamesList() async {
    //Reset user games list
    for (var localGame in Common.allGamesList) {
      localGame.isInLibrary = false;
    }

    var allDataFuture = await owns.get();
    final allData = allDataFuture.toList();
    var user = await auth.getUser();
    for (var game in allData) {
      if (game["User Uid"] == user.id) {
        for (var localGame in Common.allGamesList) {
          if (localGame.name == game["Game Uid"]) {
            localGame.isInLibrary = true;
          }
        }
      }
    }
  }

  ///Remove game from user library
  static Future<void> removeFromUserLibrary(Game localGame) async {
    var user = await auth.getUser();

    var allDataFuture = await owns.get();
    final allData = allDataFuture.toList();
    if (auth.isSignedIn) {
      for (var game in allData) {
        if (game["User Uid"] == user.id && game["Game Uid"] == localGame.name) {
          owns.document(game.id).delete();
        }
      }
    }
    localGame.isInLibrary = false;
  }

  ///Add game to user library on the database
  static Future<void> addToUserLibrary(Game game) async {
    var user = await auth.getUser();
    return owns
        .document(UniqueKey().toString())
        .set({'Game Uid': game.name, 'User Uid': user.id})
        .then((value) => print("Game added to user library"))
        .catchError(
            (error) => print("Failed to add game to user library: $error"));
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
  static Future<void> signIn(
      String email, String password, BuildContext context) async {
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
      ShellScripts.launchGame(game);
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

  ///Add a download to a game
  static incrementDownloads(Game game) async {
    await games.document(game.name).update({downloads: game.downloads + 1});
    game.downloads++;
  }
}
