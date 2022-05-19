import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_widgets/custom_colors.dart';
import 'main/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseAuth.initialize(
      'AIzaSyB-rpiGCDAUXScHzmUXAhaIuSTJ5cP7SwE', VolatileStore());
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
  runApp(const MyAppDesktop());
}

class MyAppDesktop extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  const MyAppDesktop({Key? key}) : super(key: key);

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
