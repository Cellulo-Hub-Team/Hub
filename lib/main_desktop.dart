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
                  brightness: Brightness.light),
              themeMode: currentMode,
              home: const WelcomeScreen());
        });
  }
}
