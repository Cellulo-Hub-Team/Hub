import 'package:cellulo_hub/main/custom_widgets/custom_elevated_button.dart';
import 'package:cellulo_hub/main/custom_widgets/custom_icon_button.dart';
import 'package:cellulo_hub/main/game_description.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print(DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      final snackBar = Common.checkSnackBar(
          Common.darkTheme ? "Switched to Night mode" : "Switched to Day mode");
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Future.delayed(const Duration(seconds: 3),
          () => ScaffoldMessenger.of(context).hideCurrentSnackBar());
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
            CustomElevatedButton(
              label: "My Games",
              icon: FontAwesome.gamepad,
              color: CustomColors.greenColor.shade900,
              onPressed: () => _goToTarget(const MyGames()),
            ),
            const Spacer(),
            CustomElevatedButton(
              label: "Shop",
              icon: Entypo.shop,
              color: CustomColors.blueColor.shade900,
              onPressed: () => _goToTarget(const Shop()),
            ),
            const Spacer(),
            CustomElevatedButton(
              label: "Progress",
              icon: Octicons.graph,
              color: CustomColors.redColor.shade900,
              onPressed: () => _goToTarget(const Progress()),
            ),
            const Spacer(flex: 2),
          ],
        )),
        Container(
          padding: EdgeInsets.all(30),
            alignment: Alignment.bottomRight,
            child: CustomIconButton(
                label: "Theme",
                icon:
                    Common.darkTheme ? Icons.wb_sunny : Icons.wb_sunny_outlined,
                color: CustomColors.yellowColor.shade900,
                onPressed: _switchTheme))
      ],
    ));
  }
}
