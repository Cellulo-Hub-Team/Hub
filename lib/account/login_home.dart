import 'package:cellulo_hub/account/sign_up.dart';
import 'package:cellulo_hub/api/facebook_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../main.dart';
import '../main/common.dart';
import '../main/custom_colors.dart';
import 'login.dart';

class LoginHome extends StatefulWidget {
  const LoginHome({Key? key}) : super(key: key);

  @override
  State<LoginHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  ///Redirect to the login page
  _onPressedLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  ///Redirect to the signup page
  _onPressedSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Signup()),
    );
  }

  //TODO Ne pas afficher si Linux
  ///Launch the facebook authentication page
  _onPressedFacebook() async{
    if(await FacebookApi.isLoggedIn()){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MainMenu()));
      AccessToken? token = await FacebookApi.auth.accessToken;
      print(token!.userId);
      final snackBar = Common.checkSnackBar("You're already logged in with facebook");
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Future.delayed(const Duration(seconds: 6),
              () => ScaffoldMessenger.of(context).hideCurrentSnackBar());
    }
    else {
      final LoginResult result = await FacebookAuth.instance
          .login(); // by default we request the email and the public profile
      if (result.status == LoginStatus.success) {
        // you are logged
        final AccessToken accessToken = result.accessToken!;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainMenu()));
        print(accessToken.userId);
      } else {
        print(result.status);
        print(result.message);
      }
    }
  }

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.purpleColor.shade900;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton.icon(
                onPressed: _onPressedLogin,
                icon: const Icon(
                  Ionicons.md_key,
                  color: Colors.white,
                  size: 30,
                ),
                label: const Text(" Login", style: TextStyle(fontSize: 24)),
                style: ElevatedButton.styleFrom(
                    primary: CustomColors.currentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    fixedSize: const Size(300, 100))),
            const SizedBox(height: 50),
            ElevatedButton.icon(
                onPressed: _onPressedSignUp,
                icon: const Icon(
                  Ionicons.md_person_add,
                  color: Colors.white,
                  size: 30,
                ),
                label: const Text(" Sign Up", style: TextStyle(fontSize: 24)),
                style: ElevatedButton.styleFrom(
                    primary: CustomColors.currentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    fixedSize: const Size(300, 100))),
            const SizedBox(height: 50),
            ElevatedButton.icon(
                onPressed: _onPressedFacebook,
                icon: const Icon(
                  Icons.facebook,
                  color: Colors.white,
                  size: 30,
                ),
                label: const Text("Facebook", style: TextStyle(fontSize: 24)),
                style: ElevatedButton.styleFrom(
                    primary: CustomColors.currentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    fixedSize: const Size(300, 100))),
          ],
        ),
      ),
    );
  }
}
