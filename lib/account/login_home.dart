import 'package:cellulo_hub/account/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

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
            /*ElevatedButton(
                onPressed: _onPressedLogin,
                child: const Text('Login', style: TextStyle(fontSize: 24)),
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 100), primary: CustomColors.currentColor)),*/
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
          ],
        ),
      ),
    );
  }
}
