import 'dart:io';
import 'dart:typed_data';

import 'package:cellulo_hub/charts/time_played_data_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../game/game.dart';
import '../main/achievement.dart';
import '../main/common.dart';

class FlutterfireApi {
  static firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  static firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref().child('/Games/');
  static Future<Directory> appDocDir = getApplicationDocumentsDirectory();
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static CollectionReference games =
      FirebaseFirestore.instance.collection('games');
  static CollectionReference owns =
      FirebaseFirestore.instance.collection('owns');
  static CollectionReference timePlayed =
      FirebaseFirestore.instance.collection('timePlayed');
  static const String gameName = 'Game Name',
      gameNameUnity = 'Game Name Unity',
      companyName = 'Company Name',
      companyNameUnity = 'Company Name Unity',
      companyLink = 'Company Link',
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
      apk = 'apkName',
      isConfirmed = 'isConfirmed';

  /// Build the list of all games stored on Firebase
  static Future<void> buildAllGamesList() async {
    Common.allGamesList.clear();
    QuerySnapshot querySnapshot = await games.where(isConfirmed, isEqualTo: true).get();
    final allData = querySnapshot.docs.toList();
    for (var game in allData) {
      String? androidUrl =
          game["Android Build"] == "" ? null : game["Android Build"];
      String? linuxUrl = game["Linux Build"] == "" ? null : game["Linux Build"];
      String? companyUrl = game["Company Link"] == "" ? null : game["Company Link"];
      String? windowsUrl =
          game["Windows Build"] == "" ? null : game["Windows Build"];
      String? webUrl = game["Web Link"] == "" ? null : game["Web Link"];
      Game _toAdd = Game(
          game.id,
          game[gameNameUnity],
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
      _toAdd.isInstalled = await gameIsInstalled(_toAdd);
      Common.allGamesList.add(_toAdd);
      Achievement.getAchievements(_toAdd);
    }
    checkTimePlayed();
  }

  ///Creates the local list of games the player owns
  static Future<void> buildUserGamesList() async {
    User? user = auth.currentUser;
    for (var localGame in Common.allGamesList) {
      localGame.isInLibrary = false;
    }

    QuerySnapshot querySnapshot =
        (await owns.where('User Uid', isEqualTo: user?.uid).get());
    final allData = querySnapshot.docs.toList();

    for (var game in allData) {
      for (var localGame in Common.allGamesList) {
        if (localGame.name == game.get("Game Uid")) {
          localGame.isInLibrary = true;
        }
      }
    }
  }

  ///Checks whether the game is currently installed on this device
  static Future<bool> gameIsInstalled(Game game) {
    return DeviceApps.isAppInstalled(createPackageName(game));
  }

  ///Add game to user library on the database
  static Future<void> addToUserLibrary(Game game) async {
    User? user = auth.currentUser;
    return owns
        .doc()
        .set({'Game Uid': game.name, 'User Uid': user?.uid})
        .then((value) => print("Game added to user library"))
        .catchError(
            (error) => print("Failed to add game to user library: $error"));
  }

  ///Remove game from user library
  static Future<void> removeFromUserLibrary(
      Game game, BuildContext context) async {
    User? user = auth.currentUser;
    if (user != null) {
      (await owns
              .where('Game Uid', isEqualTo: game.name)
              .where('User Uid', isEqualTo: user.uid)
              .get())
          .docs
          .first
          .reference
          .delete()
          .whenComplete(() => Common.showSnackBar(context,
              '${game.name} has successfully been deleted from your game list !'));
      game.isInLibrary = false;
    }
  }

  ///Launches url corresponding to the web version of the game
  static void launchWebApp(Game game) async {
    String? url = game.webUrl;
    if (await canLaunch(url!)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ///Download the game (game) appropriate to the OS
  static Future<void> downloadFile(Game game) async {
    String path = (await appDocDir)
        .path; //get the path to the application (data/user/0/...)
    File downloadToFile;

    if (Common.isAndroid) {
      //TODO iOs version
      if (await File('$path/${game.apkName}').exists()) {
        Common.openFile('$path/${game.apkName}');
        return;
      }
      downloadToFile = File(
          '$path/${game.apkName}'); //declare where the apk with be store (in the Application Documents right now)
      firebase_storage.DownloadTask task =
          ref.child(game.name).child(game.apkName).writeToFile(downloadToFile);
      task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
        game.downloading =
            snapshot.bytesTransferred / snapshot.totalBytes * 100;
        print('Progress game: ${game.downloading} %');
      });
      try {
        await task; //download from FirebaseStorage and write into the right file
      } on firebase_core.FirebaseException catch (e) {
        if (e.code == 'permission-denied') {
          print('User does not have permission to upload to this reference.');
        }
      }
      Common.openFile(
          '$path/${game.apkName}'); //open the apk = message to install it

    } else {
      downloadToFile = File('');
    }
  }

  ///Basic Email+password signUp (found on FirebaseAuth doc)
  static Future<int> signUp(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Common.showSnackBar(context, 'The password provided is too weak.');
        return -1;
      } else if (e.code == 'email-already-in-use') {
        Common.showSnackBar(
            context, 'The account already exists for that email.');
        print('The account already exists for that email.');
        return -1;
      }
    } catch (e) {
      print(e);
      return -1;
    }
    return 0;
  }

  ///Basic Email+password signIn (found on FirebaseAuth doc)
  static Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await buildUserGamesList();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Common.showSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Common.showSnackBar(context, 'Wrong password provided for that user.');
      }
    }
  }

  ///Launches game (game)
  static void launchApp(Game game) async {
    if (game.isInstalled) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String _packageName = createPackageName(game);
      bool _isInstalled = await DeviceApps.isAppInstalled(_packageName);

      if (_isInstalled) {
        DeviceApps.openApp(_packageName);
      } else {
        OpenFile.open('${appDocDir.path}/${game.unityName}.apk');
      }
    }
  }

  ///Generate the name of the package according to the game company and an optional name
  static String createPackageName(Game game) {
    return ('com.${game.unityCompanyName}.${game.unityName}'
        .replaceAll(' ', ''));
  }

  ///Upload the a Uint8List to the Firebase storage given the name of the file
  static Future<void> uploadFile(
      Uint8List fileToUpload, firebase_storage.Reference? reference) async {
    Uint8List file = fileToUpload;
    if (reference != null) {
      try {
        await reference.putData(file);
      } on firebase_core.FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
        print(e);
      }
    }
  }

  ///Create a new game in the database with the given parameters
  static Future<void> createNewGame(
      String _gameName,
      String _gameNameUnity,
      String _companyName,
      String _companyNameUnity,
      String _companyLink,
      String _gameDescription,
      String _gameInstructions,
      String _webBuild,
      String _webLink,
      String _linuxBuild,
      String _windowsBuild,
      String _androidBuild,
      String _backgroundImage,
      int _physicalPercentage,
      int _cognitivePercentage,
      int _socialPercentage,
      int _celluloCount,
      String apkName) async {
    return games
        .doc(_gameName)
        .set({
          gameNameUnity: _gameNameUnity,
          companyName: _companyName,
          companyNameUnity: _companyNameUnity,
          companyLink: _companyLink,
          gameDescription: _gameDescription,
          gameInstructions: _gameInstructions,
          webBuild: _webBuild,
          webLink: _webLink,
          linuxBuild: _linuxBuild,
          windowsBuild: _windowsBuild,
          androidBuild: _androidBuild,
          backgroundImage: _backgroundImage,
          physicalPercentage: _physicalPercentage,
          cognitivePercentage: _cognitivePercentage,
          socialPercentage: _socialPercentage,
          celluloCount: _celluloCount,
          downloads: 0,
          apk: apkName,
          isConfirmed: false
        })
        .then((value) => print("Game added"))
        .catchError((error) => print("Failed to add game: $error"));
  }

  ///Navigate through Firebase storage main bucket
  static firebase_storage.Reference navigateStorage(
      String gameDirectory, String fileName,
      [String? directory2, String? directory3]) {
    if (directory3 != null) {
      return ref
          .child(gameDirectory)
          .child(directory2!)
          .child(directory3)
          .child(fileName);
    } else if (directory2 != null) {
      return ref.child(gameDirectory).child(directory2).child(fileName);
    } else {
      return ref.child(gameDirectory).child(fileName);
    }
  }

  ///Check if a user is logged in
  static bool isLoggedIn() {
    return auth.currentUser != null;
  }

  ///Add a download to a game
  static incrementDownloads(Game game) async {
    await games.doc(game.name).update({downloads: game.downloads + 1});
    game.downloads++;
  }

  ///Get the number of hours per day of the week
  ///@return a map where each day of the week is mapped to the number of hours played
  /// e.g {'Monday': 1.2, 'Tuesday': 2.1,...}
  static Future<Map<String, double>> getUserTimePlayedThisWeek() async{
    QuerySnapshot querySnapshot = await timePlayed.where('User Uid', isEqualTo: auth.currentUser?.uid).get();
    Map<String, double> week = {'Monday': 0, 'Tuesday': 0, 'Wednesday': 0, 'Thursday': 0, 'Friday': 0, 'Saturday': 0, 'Sunday': 0};
    var data = querySnapshot.docs.toList();
    for(var game in data){
      Map<String, Object> map = game.data() as Map<String, Object>;
      map..remove('Time')..remove('User Uid');
      for(var dates in map.keys){
        DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(dates));
        if(TimePlayedDataBuilder.isThisWeek(date)){
          week.update(week.keys.toList()[date.weekday - 1], (value) => value += ((map[dates]! as int) / 60.0 ));
        }
      }
    }
    return week;
  }

  ///Check if the time played locally is different from the one stored in the database, and create a timestamp with the time played recently if needed
  static void checkTimePlayed() async{
    DocumentReference? reference = auth.currentUser?.uid != null ? timePlayed.doc(auth.currentUser?.uid) : null;
    if(reference != null){
      DocumentSnapshot query = await reference.get();
      int timePlayedLocally = Common.getTotalTimePlayed();
      int timePlayedDatabase = query.get('Time');
      if(timePlayedLocally != timePlayedDatabase){
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        reference.update({timestamp : timePlayedLocally - timePlayedDatabase});
        reference.update({'Time': timePlayedLocally});
      }
    }
  }

  ///Get the number of hours played this week
  static Future<double> timePlayedThisWeek() async {
    double timePlayed = 0;
    var map = await getUserTimePlayedThisWeek();
    for(var day in map.keys){
      timePlayed += map[day]!;
    }
    return timePlayed;
  }
}
