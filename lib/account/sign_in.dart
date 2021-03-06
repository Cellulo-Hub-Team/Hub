import 'package:cellulo_hub/api/firedart_api.dart';
import 'package:cellulo_hub/custom_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../api/flutterfire_api.dart';
import '../custom_widgets/custom_colors.dart';
import '../custom_widgets/custom_scaffold.dart';
import '../main.dart';
import '../main/common.dart';
import 'forgot_password.dart';
import 'profile_home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // The node used to request the keyboard focus.
  final FocusNode _focusNode = FocusNode();

  ///Redirect to the reset password page
  _onPressedForgot() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPassword()),
    );
  }

  ///Sign in using email and password based on what platform the user is using
  _onPressed() async {
    if (Common.isDesktop) {
      await FiredartApi.signIn(
          _emailController.text, _passwordController.text, context);
      if (FiredartApi.isLoggedIn()) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainMenu()));
      }
    } else {
      await FlutterfireApi.signIn(
          _emailController.text, _passwordController.text, context);
      if (FlutterfireApi.isLoggedIn()) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainMenu()));
      }
    }
  }

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.purpleColor();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      name: "Login",
      leadingIcon: Ionicons.md_person,
      leadingName: "Profile",
      leadingScreen: Activity.Profile,
      leadingTarget: const ProfileHome(),
      hasFloating: false,
      body: RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (RawKeyEvent event) {
        if (event.data.logicalKey == LogicalKeyboardKey.enter && _passwordController.text != "") {
          _onPressed();
        }
      },
      child: Center(
          child: SizedBox(
              width: 800,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 5),
                  TextField(
                    cursorColor: CustomColors.darkThemeColor(),
                    style: TextStyle(color: CustomColors.darkThemeColor()),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "User Email",
                      prefixIcon: Icon(Icons.mail,
                          color: CustomColors.darkThemeColor()),
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    cursorColor: CustomColors.darkThemeColor(),
                    style: TextStyle(color: CustomColors.darkThemeColor()),
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "User Password",
                      prefixIcon: Icon(Icons.lock,
                          color: CustomColors.darkThemeColor()),
                    ),
                  ),
                  TextButton(
                    onPressed: _onPressedForgot,
                    child: const Text(
                      'Forgot your password ?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const Spacer(),
                  CustomElevatedButton(label: "Login", onPressed: _onPressed),
                  const Spacer(flex: 5)
                ],
              )))),
    );
  }
}
