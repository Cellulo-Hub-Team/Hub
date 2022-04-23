import 'package:cellulo_hub/custom_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../api/firebase_api.dart';
import '../custom_widgets/custom_colors.dart';
import '../custom_widgets/custom_scaffold.dart';
import 'login_home.dart';

class Forgot extends StatefulWidget {
  const Forgot({Key? key}) : super(key: key);

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
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
      name: "Login",
      leading: Ionicons.md_person,
      leadingTarget: const LoginHome(),
      hasFloating: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(flex: 5),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "User Email",
              prefixIcon: Icon(Icons.mail, color: Colors.black),
            ),
          ),
          Spacer(),
          CustomElevatedButton(
              label: "Reset Password",
              onPressed: () {
                FirebaseApi.auth
                    .sendPasswordResetEmail(email: _emailController.text);
              }),
          Spacer(flex: 5),
        ],
      ),
    );
  }
}
