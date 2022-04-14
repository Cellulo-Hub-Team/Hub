import 'package:flutter/material.dart';

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
            child: Text("Welcome Test${FirebaseApi.auth.currentUser!.email}", style: TextStyle(fontSize: 20),),
          ),
          SizedBox(height: 30),
          Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: CustomColors.currentColor),
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  await FirebaseApi.auth.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginHome()),
                  );
                },
                child: const Text('Log out'),
              ))
        ],
      ),
    );
  }
}
