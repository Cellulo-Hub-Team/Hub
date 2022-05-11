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


class FirebaseApi {
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
  static String companyName = 'Company Name',
      gameDescription = 'Game Description',
      webBuild =  'Web Build',
      webLink = 'Web Link',
      linuxBuild = 'Linux Build',
      androidBuild = 'Android Build',
      backgroundImage = 'Background Image',
      downloads = 'Downloads';

  /// Build the list of all games stored on Firebase
  static Future<void> buildAllGamesList() async {
    QuerySnapshot querySnapshot = await games.get();
    final allData = querySnapshot.docs.map((doc) => doc).toList();
    for (var game in allData) {
      String backgroundUrl = await ref.child(game.get(backgroundImage)).getDownloadURL();
      String? androidUrl = game.get(androidBuild) == ""
          ? null
          : game.get(androidBuild);
      String? linuxUrl = game.get(linuxBuild) == ""
          ? null
          : await ref.child(game.get(linuxBuild)).getDownloadURL();
      String? webUrl = game.get(webLink) == ""
          ? null
          : game.get(webLink);
      Random source = Random();

      Game _toAdd = Game(
          game.id,
          backgroundUrl,
          game.get(gameDescription),
          androidUrl,
          linuxUrl,
          webUrl,
          source.nextDouble(),
          source.nextDouble(),
          source.nextDouble(),
          game.get(companyName),
          game.get(downloads));
      if(_toAdd.androidBuild != null){
        _toAdd.isInstalled = await gameIsInstalled(_toAdd);
      }
      Common.allGamesList.add(_toAdd);
    }
  }

  ///Build the list of all game for the current user
  static Future<void> buildUserGamesList() async {
    QuerySnapshot querySnapshot = await userGames.get();
    final allData = querySnapshot.docs.map((doc) => doc).toList();
    User? user = auth.currentUser;
    //Reset current user games list
    for (var localGame in Common.allGamesList){
      localGame.isInLibrary = false;
    }
    //Create new user games list
    for (var game in allData){
      if (game.get("User Uid") == user?.uid){
        for (var localGame in Common.allGamesList){
          if (localGame.name == game.get("Game Uid")){
            localGame.isInLibrary = true;
          }
        }
      }
    }
  }

  ///Check if a game is installed on the device
  static Future<bool> gameIsInstalled(Game game) {
    return DeviceApps.isAppInstalled(createPackageName(game));
  }

  ///Add the game to the current user library
  static Future<void> addToUserLibrary(Game game) async {
    User? user = auth.currentUser;
    return userGames
        .doc()
        .set({'Game Uid': game.name, 'User Uid': user?.uid})
        .then((value) => print("Game added to user library"))
        .catchError(
            (error) => print("Failed to add game to user library: $error"));
  }

  ///
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

    if (Common.isAndroid) {
      if(await File('$path/$apkName').exists()) {
        Common.openFile('$path/$apkName');
        return;
      }

      downloadToFile = File(
          '$path/$apkName'); //declare where the apk with be store (in the Application Documents right now)
    } else if (Common.isLinux) {
      downloadToFile =
          File((await getDownloadsDirectory())!.path); //to download directory
    } else if (Common.isWeb) {
      return;
    } else {
      downloadToFile = File('');
    }
    firebase_storage.DownloadTask task = ref.child(game.androidBuild ?? "Wrong path").writeToFile(downloadToFile);
    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
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
      buildUserGamesList();
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
        return ('com.${game.company}.${game.name}'.toLowerCase().replaceAll(' ', ''));
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

  ///Create a new game with
  static Future<void> createNewGame(
      String companyName,
      String gameName,
      String gameDescription,
      firebase_storage.Reference? webZip,
      firebase_storage.Reference? linuxZip,
      firebase_storage.Reference? apkName,
      firebase_storage.Reference? backgroundImage,
      String webLink) async {
    String webZipPath = webZip == null
        ? ''
        : webZip.fullPath.substring(6, webZip.fullPath.length);
    String linuxZipPath = linuxZip == null
        ? ''
        : linuxZip.fullPath.substring(6, linuxZip.fullPath.length);
    String apkNamePath = apkName == null
        ? ''
        : apkName.fullPath.substring(6, apkName.fullPath.length);
    String backgroundImagePath = backgroundImage == null
        ? ''
        : backgroundImage.fullPath
        .substring(6, backgroundImage.fullPath.length);
    return games
        .doc(gameName)
        .set({
      FirebaseApi.companyName: companyName,
      FirebaseApi.gameDescription: gameDescription,
      FirebaseApi.webBuild: webZipPath,
      FirebaseApi.webLink: webLink,
      FirebaseApi.linuxBuild: linuxZipPath,
      FirebaseApi.androidBuild: apkNamePath,
      FirebaseApi.backgroundImage: backgroundImagePath,
      downloads: 0
    })
        .then((value) => print("Game Added"))
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

  ///Get the current user, can be null
  static User? getUser() {
    return auth.currentUser;
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
