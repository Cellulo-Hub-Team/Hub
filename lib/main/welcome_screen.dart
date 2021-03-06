import 'package:flutter/material.dart';

import '../account/profile_home.dart';
import '../api/facebook_api.dart';
import '../api/firedart_api.dart';
import '../api/flutterfire_api.dart';
import '../main.dart';
import 'common.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  ///Build local games lists and get to login screen or main menu depending if user is logged in or not
  Future<Widget> _getStartingScreen() async {
    if (Common.isDesktop) {
      if (FiredartApi.isLoggedIn()) {
        await FiredartApi.buildAllGamesList();
        await FiredartApi.buildUserGamesList();
        return const MainMenu();
      }
      return const ProfileHome();
    } else {
      await FlutterfireApi.buildAllGamesList();
      if (FlutterfireApi.isLoggedIn() || await FacebookApi.isLoggedIn()) {
        await FlutterfireApi.buildUserGamesList();
        return const MainMenu();
      }
      return const ProfileHome();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 3),
        () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FutureBuilder(
                          future: _getStartingScreen(),
                          builder: (BuildContext context,
                              AsyncSnapshot<Widget> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return snapshot.data!;
                            }
                          },
                        )),
              )
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Image.asset('graphics/logo_chili.png', scale: 3)));
  }
}
