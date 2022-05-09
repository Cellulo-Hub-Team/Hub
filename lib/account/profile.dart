import 'package:cellulo_hub/custom_widgets/custom_elevated_button.dart';
import 'package:cellulo_hub/custom_widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';

import '../api/facebook_api.dart';
import '../api/firebase_api.dart';
import '../main.dart';
import '../custom_widgets/custom_colors.dart';
import '../main/common.dart';
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
    } else if (FacebookApi.loggedWithFacebook) {
      await FacebookApi.logout();
      FacebookApi.loggedWithFacebook = false;
    }
    Common.goToTarget(context, const ProfileHome(), false, Activity.Profile);
  }

  Future<String> _getCurrentAuth() async {
    if (FirebaseApi.isLoggedIn()) {
      return (FirebaseApi.getUser()!.email)!;
    } else if (FacebookApi.loggedWithFacebook) {
      Map<String, dynamic> userData =
          await FacebookApi.auth.getUserData(fields: 'name,friends');
      print(userData['friends']);
      return userData['name'];
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
        leadingIcon: Icons.home,
        leadingName: "Menu",
        leadingScreen: Activity.Menu,
        leadingTarget: const MainMenu(),
        hasFloating: false,
        body: Center(child: Column(
          children: [
            const Spacer(flex: 3),
            FutureBuilder(
              future: _getCurrentAuth(),
              builder: (BuildContext context,
                  AsyncSnapshot<String> snapshot) {
                if (!snapshot.hasData) {
                  // while data is loading:
                  return const CircularProgressIndicator();
                } else {
                  // data loaded:
                  final output = snapshot.data;
                  return Center(
                    child:
                    Text('Welcome $output'),
                  );
                }
              },
            ),
            const Spacer(),
            CustomElevatedButton(
              label: "Log out",
              onPressed: _signOut
              ),
            const Spacer(flex: 3)
          ]))
    );
  }
}
