import 'package:cellulo_hub/custom_widgets/custom_elevated_button.dart';
import 'package:cellulo_hub/custom_widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';

import '../api/firebase_api.dart';
import '../main.dart';
import '../custom_widgets/custom_colors.dart';
import 'login_home.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
        hasFloating: false,
        child: Center(child: Column(
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
                  MaterialPageRoute(builder: (context) => const LoginHome()),
                );
              }),
            Spacer(flex: 3)
          ]))
    );
  }
}
