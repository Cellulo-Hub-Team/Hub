import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../api/firebase_api.dart';
import '../main.dart';
import '../main/custom_colors.dart';

import 'forgot_password.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  ///Redirect to the reset password page
  _onPressedForgot() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Forgot()),
    );
  }

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.purpleColor.shade900;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.currentColor,
        title: const Text('Login'),
        leading: IconButton(
          icon: Icon(Ionicons.md_person),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "User Email",
              prefixIcon: Icon(Icons.mail, color: Colors.black),
            ),
          ),
          TextField(
            obscureText: true,
            controller: _passwordController,
            decoration: const InputDecoration(
              hintText: "User Password",
              prefixIcon: Icon(Icons.lock, color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: _onPressedForgot,
            child: const Text(
              'Forgot your password ?',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: CustomColors.currentColor),
            onPressed: () async {
              // Validate returns true if the form is valid, or false otherwise.
              await FirebaseApi.signIn(
                  _emailController.text, _passwordController.text);
              if (FirebaseApi.isLoggedIn()) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MainMenu()));
              }
            },
            child: const Text('Log in'),
          ),
        ],
      ),
    );
  }
}
