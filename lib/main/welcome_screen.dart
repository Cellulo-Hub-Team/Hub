import 'package:flutter/material.dart';

import '../account/profile_home.dart';
import '../api/facebook_api.dart';
import '../api/firebase_api.dart';
import '../main.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  Future<Widget> _getStartingScreen() async {
    if (!FirebaseApi.isLoggedIn() && !(await FacebookApi.isLoggedIn())) {
      FirebaseApi.buildAllGamesList();
      return const ProfileHome();
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
            () => {
                Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              FutureBuilder(
                future: _getStartingScreen(),
                builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                  if(!snapshot.hasData){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else{
                    return snapshot.data!;
                  }
                },
              )),
            )}
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
