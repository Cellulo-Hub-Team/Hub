import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'account/profile.dart';
import 'firebase_options.dart';
import 'main/common.dart';
import 'main/custom_colors.dart';
import 'main/my_games.dart';
import 'main/progress.dart';
import 'main/shop.dart';
import 'main/welcome_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() async {
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
                  brightness: Brightness.light,
                  accentColor: Colors.white),
              darkTheme: ThemeData(
                  textTheme: GoogleFonts.comfortaaTextTheme(),
                  scaffoldBackgroundColor: CustomColors.blackColor.shade900,
                  brightness: Brightness.dark,
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
  _onPressedMyGames() {
    Common.resetOpenGameExpansionPanels();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyGames()),
    );
  }

  _onPressedShop() {
    Common.resetOpenGameExpansionPanels();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Shop()),
    );
  }

  _onPressedProgress() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Progress()),
    );
  }

  _onPressedDark() {
    setState(() {
      Common.darkTheme = !Common.darkTheme;
      MyApp.themeNotifier.value = Common.darkTheme ? ThemeMode.dark : ThemeMode.light;
      CustomColors.currentColor = CustomColors.greyColor.shade900;
      final snackBar = Common.checkSnackBar(Common.darkTheme ? "Switched to Night mode" : "Switched to Day mode");
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Future.delayed(const Duration(seconds: 3),
              () => ScaffoldMessenger.of(context).hideCurrentSnackBar());
    });
  }

  _onPressedProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Profile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                        onPressed: _onPressedMyGames,
                        icon: const Icon(
                          FontAwesome.gamepad,
                          color: Colors.white,
                          size: 30,
                        ),
                        label: const Text(" My Games", style: TextStyle(fontSize: 25)),
                        style: ElevatedButton.styleFrom(
                            primary: CustomColors.greenColor.shade900,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            fixedSize: const Size(300, 100))),
                    const SizedBox(height: 50),
                    ElevatedButton.icon(
                        onPressed: _onPressedShop,
                        icon: const Icon(
                          Entypo.shop,
                          color: Colors.white,
                          size: 30,
                        ),
                        label: const Text(" Shop", style: TextStyle(fontSize: 25)),
                        style: ElevatedButton.styleFrom(
                            primary: CustomColors.blueColor.shade900,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            fixedSize: const Size(300, 100))),
                    const SizedBox(height: 50),
                    ElevatedButton.icon(
                        onPressed: _onPressedProgress,
                        icon: const Icon(
                          Octicons.graph,
                          color: Colors.white,
                          size: 30,
                        ),
                        label: const Text(" Progress", style: TextStyle(fontSize: 25)),
                        style: ElevatedButton.styleFrom(
                            primary: CustomColors.redColor.shade900,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            fixedSize: const Size(300, 100))),
                    const SizedBox(height: 50),
                    ElevatedButton(
                        onPressed: _onPressedProgress,
                        child: const Text("Why don't you try beating your highscore on Golf Sheep game today?",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,),
                        style: ElevatedButton.styleFrom(
                            primary: CustomColors.greyColor.shade900,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                            fixedSize: const Size(300, 100))
                    ),
                  ],
                )),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: const EdgeInsets.only(right: 50, bottom: 70),
                    child: ElevatedButton(
                        onPressed: _onPressedDark,
                        style: ElevatedButton.styleFrom(
                            primary: CustomColors.yellowColor.shade900,
                            fixedSize: const Size(70, 70),
                            shape: const CircleBorder()),
                        child: Icon(Common.darkTheme
                            ? Icons.wb_sunny
                            : Icons.wb_sunny_outlined,
                            size: 36)))),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                    padding: const EdgeInsets.only(left: 50, bottom: 70),
                    child: ElevatedButton(
                        onPressed: _onPressedProfile,
                        style: ElevatedButton.styleFrom(
                            primary: CustomColors.purpleColor.shade900,
                            fixedSize: const Size(70, 70),
                            shape: const CircleBorder()),
                        child: const Icon(Ionicons.md_person,
                            size: 36))))
          ],
        ));
  }
}