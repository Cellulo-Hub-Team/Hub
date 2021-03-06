import 'package:cellulo_hub/api/firedart_api.dart';
import 'package:cellulo_hub/custom_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../api/flutterfire_api.dart';
import '../custom_widgets/custom_scaffold.dart';
import '../main/common.dart';
import 'profile_home.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      name: "Reset password",
      leadingIcon: Ionicons.md_person,
      leadingName: "Profile",
      leadingScreen: Activity.Profile,
      leadingTarget: const ProfileHome(),
      hasFloating: false,
      body: Center(
      child: SizedBox(
      width: 800,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 5),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "User Email",
              prefixIcon: Icon(Icons.mail, color: Colors.black),
            ),
          ),
          const Spacer(),
          CustomElevatedButton(
              label: "Reset Password",
              onPressed: () {
                Common.isDesktop
                    ? FiredartApi.auth.resetPassword(_emailController.text)
                    : FlutterfireApi.auth
                        .sendPasswordResetEmail(email: _emailController.text);
              }),
          const Spacer(flex: 5),
        ],
      ))),
    );
  }
}
