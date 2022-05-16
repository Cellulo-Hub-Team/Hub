import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'account/profile.dart';
import 'custom_widgets/custom_menu_button.dart';
import 'custom_widgets/custom_icon_button.dart';
import 'custom_widgets/style.dart';
import 'firebase_options.dart';
import 'main/common.dart';
import 'custom_widgets/custom_colors.dart';
import 'main/my_games.dart';
import 'main/progress.dart';
import 'main/settings.dart';
import 'main/shop.dart';
import 'main/welcome_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Achievement {
  final String label;
  final String type;
  final int steps;

  Achievement(this.label, this.type, this.steps);

  Achievement.fromJson(Map<String, dynamic> json)
      : label = json['label'],
        type = json['type'],
        steps = json['steps'];

  Map<String, dynamic> toJson() =>
      {'label': label, 'type': type, 'steps': steps};
}

void main() async {
  /*
  var path =
      "C:/Users/antoi/AppData/LocalLow/DefaultCompany/Achievements/achievements.json";
  File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(new LineSplitter())
      .forEach((l) {
    Map<String, dynamic> achievementMap = jsonDecode(l);
    var achievement = Achievement.fromJson(achievementMap);

    print(achievement.label);
  });
  */

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kIsWeb) {
    // initialize the facebook javascript SDK
    await FacebookAuth.i.webInitialize(
      appId: "5399562753408881",
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  textTheme: GoogleFonts.comfortaaTextTheme(),
                  brightness: Brightness.light),
              darkTheme: ThemeData(
                  textTheme: GoogleFonts.comfortaaTextTheme(),
                  scaffoldBackgroundColor: CustomColors.blackColor,
                  brightness: Brightness.dark),
              themeMode: currentMode,
              home: const WelcomeScreen());
        });
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Center(
            child: Column(
          children: [
            const Spacer(flex: 2),
            Text("Main menu", style: Style.titleStyle()),
            const Spacer(),
            CustomMenuButton(
              label: "My Games",
              icon: FontAwesome.gamepad,
              color: CustomColors.greenColor(),
              onPressed: () => Common.goToTarget(
                  context, const MyGames(), true, Activity.MyGames),
            ),
            const Spacer(),
            CustomMenuButton(
              label: "Shop",
              icon: Entypo.shop,
              color: CustomColors.blueColor(),
              onPressed: () =>
                  Common.goToTarget(context, const Shop(), true, Activity.Shop),
            ),
            const Spacer(),
            CustomMenuButton(
              label: "Progress",
              icon: Octicons.graph,
              color: CustomColors.redColor(),
              onPressed: () => Common.goToTarget(
                  context, const Progress(), true, Activity.Progress),
            ),
            const Spacer(),
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration : BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 10.0, color: Colors.grey.shade300),
                    bottom: BorderSide(width: 10.0, color: Colors.grey.shade300),
                    )),
                  child:
          ElevatedButton.icon(
              onPressed: () => Common.goToTarget(
                  context, const Progress(), true, Activity.Progress),
              icon: Icon(MaterialCommunityIcons.lightbulb_on, color: Colors.orangeAccent.shade100, size: 40),
              label: Text(" Why don't you try beating your high score in Cellulan World today ?",
                  style: TextStyle(fontSize: 20, color: CustomColors.darkThemeColor()),
                  textAlign: TextAlign.center),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: CustomColors.inversedDarkThemeColor(),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
            ),
          )),
            const Spacer(flex: 2),
          ],
        )),
        Container(
            padding: const EdgeInsets.only(right: 30, top: 30),
            alignment: Alignment.topRight,
            child: CustomIconButton(
                label: "Settings",
                icon: Ionicons.ios_settings,
                color: Colors.grey.shade500,
                onPressed: () => Common.goToTarget(
                  context, const Settings(), true, Activity.Profile))),
      ],
    ));
  }
}
