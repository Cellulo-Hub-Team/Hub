import 'dart:io';
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
  static CollectionReference games = Firestore.instance.collection('test');
  static CollectionReference owns = Firestore.instance.collection('owns');

  //Creates local list of all games available in the shop
  static Future<void> buildAllGamesList() async {
    var allGamesFuture = await games.get();
    final allGames = allGamesFuture.toList();
    for (var game in allGames) {
      print(game.id);
      String? androidUrl = game["Android Build"] == ""
          ? null
          : game["Android Build"];
      String? linuxUrl = game["Linux Build"] == ""
          ? null
          : game["Linux Build"];
      String? webUrl = game["Web Link"] == ""
          ? null
          : game["Web Link"];

      Game _toAdd = Game(
          game.id,
          game["Background Image"],
          game["Game Description"],
          androidUrl,
          linuxUrl,
          webUrl,
          game["Physical Percentage"],
          game["Cognitive Percentage"],
          game["Social Percentage"],
          game["Company Name"]);
      _toAdd.isInstalled = await gameIsInstalled(_toAdd);
      Common.allGamesList.add(_toAdd);
    }
  }


  //Creates local list of all games available in the shop
  static Future<void> buildUserGamesList() async {
    var allGamesFuture = await owns.get();
    final allGames = allGamesFuture.toList();
    var user = getUser();
    //Reset current user games list
    for (var localGame in Common.allGamesList){
      localGame.isInLibrary = false;
    }
    //Create new user games list
    for (var game in allGames){
      if (game["User Uid"] == user){
        for (var localGame in Common.allGamesList){
          if (localGame.name == game["Game Uid"]){
            localGame.isInLibrary = true;
          }
        }
      }
    }
  }

  static Future<bool> gameIsInstalled(Game game) {
    return DeviceApps.isAppInstalled(createPackageName(game));
  }

  static Future<void> addToUserLibrary(Game game) async {
    var user = getUser();
    return owns.document('test')
        .set({'Game Uid': game.name, 'User Uid': user?.uid})
        .then((value) => print("Game added to user library"))
        .catchError(
            (error) => print("Failed to add game to user library: $error"));
  }

  static void launchWebApp(Game game) async {
    String? url = game.webUrl;
    if (await canLaunch(url!)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  /*
  ///Download the game (game) appropriate to the OS
  static Future<void> downloadFile(Game game) async {
    //Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = (await appDocDir)
        .path; //get the path to the application (data/user/0/...)
    File downloadToFile;

    if (Common.isAndroid) {
      downloadToFile = File(
          '$path/${game.name.toLowerCase()}.apk'); //declare where the apk with be store (in the Application Documents right now)
    } else if (Common.isLinux) {
      downloadToFile =
          File((await getDownloadsDirectory())!.path); //to download directory
    } else if (Common.isWeb) {
      downloadToFile = File('');
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
    } on Exception catch (e) {
      //TODO exceptions
      print(e);
    }

    //TODO Check if 0 is returned then set game.isInstalled to true
    OpenFile.open(
        '$path/${game.name.toLowerCase()}.apk'); //open the apk = message to install it
  }
  */

  ///Basic Email+password signUp (found on FirebaseAuth doc)
  static Future<void>       signUp(String email, String password) async {
    try {
      await FirebaseAuth.instance.signUp(email, password);
    } on Exception catch (e) {
      print(e);
    }
  }

  ///Basic Email+password signIn (found on FirebaseAuth doc)
  static Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signIn(email, password);
      buildUserGamesList();
    } on Exception catch (e) {
      //TODO exceptions
      print(e.toString());
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
        OpenFile.open('${appDocDir.path}/${game.name.toLowerCase()}.apk');
      }
    }
  }

  ///Generate the name of the package according to the game company and an optional name
  static String createPackageName(Game game, [String? name]) {
    return name == null
        ? ('com.${game.company}.${game.name}'.toLowerCase().replaceAll(' ', ''))
        : ('com.${game.company}.$name'.toLowerCase());
  }

  ///Check if a user is logged in
  static bool isLoggedIn() {
    return auth.getUser() != null;
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
