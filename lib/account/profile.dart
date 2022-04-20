import 'package:cellulo_hub/api/facebook_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../api/firebase_api.dart';
import '../main.dart';
import '../main/custom_colors.dart';
import 'login_home.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  _signOut() async {
    if (FirebaseApi.auth.currentUser != null) {
      await FirebaseApi.auth.signOut();
    } else if ((await FacebookApi.isLoggedIn())) {
      await FacebookApi.logout();
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginHome()));
  }

  Future<String> _getCurrentAuth() async {
    if (FirebaseApi.isLoggedIn()) {
      return (FirebaseApi.getUser()!.email)!;
    } else if (await FacebookApi.isLoggedIn()) {
      Map<String, dynamic> userData =
          await FacebookApi.auth.getUserData(fields: "name");
      return userData["name"];
    }
    return 'No User';
  }

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.purpleColor.shade900;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.currentColor,
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: FutureBuilder(
                future: _getCurrentAuth(),
                builder: (BuildContext context,
                    AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData) {
                    // while data is loading:
                    return const Text('Please wait');
                  } else {
                    // data loaded:
                    final output = snapshot.data;
                    return Center(
                      child:
                          Text('Welcome $output'),
                    );
                  }
                },
              )),
          const SizedBox(height: 30),
          Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: CustomColors.currentColor),
                onPressed: _signOut,
                // Validate returns true if the form is valid, or false otherwise.
                child: const Text('Log out'),
              ))
        ],
      ),
    );
  }
}
