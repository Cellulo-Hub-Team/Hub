import 'package:cellulo_hub/custom_widgets/custom_elevated_button.dart';
import 'package:cellulo_hub/custom_widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../api/firebase_api.dart';
import '../main.dart';
import '../custom_widgets/custom_colors.dart';
import 'profile_home.dart';

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
    return CustomScaffold(
        name: "Profile",
        leading: Icons.home,
        leadingTarget: MainMenu(),
        hasFloating: false,
        body: Center(child: Column(
          children: [
            Spacer(flex: 3),
            Text("Welcome ${FirebaseApi.auth.currentUser!.email}", style: TextStyle(fontSize: 20)),
            Spacer(),
            CustomElevatedButton(
              label: "Log out",
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                await FirebaseApi.auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileHome()),
                );
              }),
            Spacer(flex: 3)
          ]))
    );
  }
}
