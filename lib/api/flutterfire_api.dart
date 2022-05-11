import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:open_file/open_file.dart';
import 'package:device_apps/device_apps.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main/common.dart';
import '../game/game.dart';
import '../main/my_games.dart';

//TODO: Trouver un moyen clean de faire une ref static/ Exceptions/ Link à firebase storage quand on aura les jeux

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
  static CollectionReference userGames =
      FirebaseFirestore.instance.collection('owns');
  static const String gameName = 'Game Name',
      gameNameUnity = 'Game Name Unity',
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

  /// Build the list of all games stored on Firebase
  static Future<void> buildAllGamesList() async {
    QuerySnapshot querySnapshot = await games.get();
    final allData = querySnapshot.docs.toList();
    for (var game in allData) {
      String? androidUrl = game["Android Build"] == "" ? null : game["Android Build"];
      String? linuxUrl = game["Linux Build"] == "" ? null : game["Linux Build"];
      String? windowsUrl = game["Windows Build"] == "" ? null : game["Windows Build"];
      String? webUrl = game["Web Link"] == "" ? null : game["Web Link"];

      Game _toAdd = Game(
        game.id,
        game[gameNameUnity],
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
      _toAdd.isInstalled = await gameIsInstalled(_toAdd);
      Common.allGamesList.add(_toAdd);
    }
  }

  //Creates the local list of games the player owns
  static Future<void> buildUserGamesList() async {
    QuerySnapshot querySnapshot = await userGames.get();
    final allData = querySnapshot.docs.toList();
    User? user = auth.currentUser;
    for (var game in allData) {
      if (game.get("User Uid") == user?.uid) {
        for (var localGame in Common.allGamesList) {
          if (localGame.name == game.get("Game Uid")) {
            localGame.isInLibrary = true;
          }
        }
      }
    }
  }

  //Checks whether the game is currently installed on this device
  static Future<bool> gameIsInstalled(Game game) {
    return DeviceApps.isAppInstalled(createPackageName(game));
  }

  //Add game to user library on the database
  static Future<void> addToUserLibrary(Game game) async {
    User? user = auth.currentUser;
    return userGames
        .doc()
        .set({'Game Uid': game.name, 'User Uid': user?.uid})
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

  ///Download the game (game) appropriate to the OS
  static Future<void> downloadFile(Game game) async {
    String? apkName = game.androidBuild?.split('/').last;
    String path = (await appDocDir)
        .path; //get the path to the application (data/user/0/...)
    File downloadToFile;

    if (Common.isAndroid) {//TODO iOs version
      if(await File('$path/$apkName').exists()) {
        Common.openFile('$path/$apkName');
        return;
      }
      downloadToFile = File('$path/$apkName'); //declare where the apk with be store (in the Application Documents right now)
    } else {
      downloadToFile = File('');
    }
    firebase_storage.DownloadTask task = ref
        .child(game.androidBuild ?? "Wrong path")
        .writeToFile(downloadToFile);
    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    });

    try {
      await task; //download from FirebaseStorage and write into the right file
    } on firebase_core.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
      // e.g, e.code == 'canceled'
    }

    if(Common.isAndroid){
      Common.openFile('$path/$apkName'); //open the apk = message to install it
    }

  }

  ///Basic Email+password signUp (found on FirebaseAuth doc)

  static Future<int> signUp(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Common.showSnackBar(context, 'The password provided is too weak.');
        return -1;
      } else if (e.code == 'email-already-in-use') {
        Common.showSnackBar(context, 'The account already exists for that email.');
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
  static Future<void> signIn(String email, String password, BuildContext context) async {
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
        OpenFile.open('${appDocDir.path}/${game.androidBuild?.split('/').last}.apk');
      }
    }
  }

  ///Generate the name of the package according to the game company and an optional name
  static String createPackageName(Game game) {
        return ('com.${game.companyName}.${game.name}'.toLowerCase().replaceAll(' ', ''));
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
      int _celluloCount) async {
    return games
        .doc(_gameName)
        .set({
          gameName: _gameNameUnity,
          companyName: _companyName,
          companyNameUnity: _companyNameUnity,
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
          downloads: 0
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
  static incrementDownloads(Game game) async{
    await games.doc(game.name).update({downloads: game.downloads + 1});
    game.downloads++;
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
