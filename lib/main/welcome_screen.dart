import 'package:flutter/material.dart';

import '../account/login_home.dart';
import '../api/firebase_api.dart';
import '../main.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  Widget _getStartingScreen() {
    if (!FirebaseApi.isLoggedIn()) {
      FirebaseApi.buildAllGamesList();
      return const LoginHome();
    } else {
      _buildLists();
      return const MainMenu();
    }
  }

  _buildLists() async {
    await FirebaseApi.buildAllGamesList();
    FirebaseApi.buildUserGamesList();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 0),
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _getStartingScreen()),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Image.asset('graphics/logo_chili.png')
        )
    );
  }
}