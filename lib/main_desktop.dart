import 'package:process_run/shell.dart';
import 'package:process_run/which.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'account/profile.dart';
import 'custom_widgets/custom_menu_button.dart';
import 'custom_widgets/custom_icon_button.dart';
import 'custom_widgets/style.dart';
import 'main/common.dart';
import 'custom_widgets/custom_colors.dart';
import 'main/my_games.dart';
import 'main/progress.dart';
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
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseAuth.initialize('AIzaSyB-rpiGCDAUXScHzmUXAhaIuSTJ5cP7SwE', VolatileStore());
  Firestore.initialize('cellulo-hub-games');

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
                  brightness: Brightness.light,
                  accentColor: Colors.white),
              darkTheme: ThemeData(
                  textTheme: GoogleFonts.comfortaaTextTheme(),
                  scaffoldBackgroundColor: CustomColors.blackColor.shade900,
                  brightness: Brightness.light,
                  accentColor: Colors.white),
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
  _goToTarget(Widget _target) {
    Common.resetOpenPanels();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _target),
    );
  }

  _switchTheme() {
    setState(() {
      Common.darkTheme = !Common.darkTheme;
      MyApp.themeNotifier.value =
      Common.darkTheme ? ThemeMode.dark : ThemeMode.light;
      CustomColors.currentColor = CustomColors.greyColor.shade900;
      Common.showSnackBar(context,
          Common.darkTheme ? "Switched to Night mode" : "Switched to Day mode");
    });
  }

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
                      color: CustomColors.greenColor.shade900,
                      onPressed: () => Common.goToTarget(
                          context, const MyGames(), true, Activity.MyGames),
                    ),
                    const Spacer(),
                    CustomMenuButton(
                      label: "Shop",
                      icon: Entypo.shop,
                      color: CustomColors.blueColor.shade900,
                      onPressed: () =>
                          Common.goToTarget(context, const Shop(), true, Activity.Shop),
                    ),
                    const Spacer(),
                    CustomMenuButton(
                      label: "Progress",
                      icon: Octicons.graph,
                      color: CustomColors.redColor.shade900,
                      onPressed: () => Common.goToTarget(
                          context, const Progress(), true, Activity.Progress),
                    ),
                    const Spacer(flex: 2),
                  ],
                )),
            Container(
                padding: const EdgeInsets.only(right: 30, bottom: 60),
                alignment: Alignment.bottomRight,
                child: CustomIconButton(
                    label: "Theme",
                    icon:
                    Common.darkTheme ? Icons.wb_sunny : Icons.wb_sunny_outlined,
                    color: CustomColors.yellowColor.shade900,
                    onPressed: () => _switchTheme())),
            Container(
                padding: const EdgeInsets.only(left: 30, bottom: 60),
                alignment: Alignment.bottomLeft,
                child: CustomIconButton(
                    label: "Profile",
                    icon: Ionicons.md_person,
                    color: CustomColors.purpleColor.shade900,
                    onPressed: () => Common.goToTarget(
                        context, const Profile(), true, Activity.Profile)))
          ],
        ));
  }
}
