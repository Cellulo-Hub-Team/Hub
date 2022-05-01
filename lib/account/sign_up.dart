import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../api/firebase_api.dart';
import '../custom_widgets/custom_elevated_button.dart';
import '../custom_widgets/custom_scaffold.dart';
import '../main/common.dart';
import '../custom_widgets/custom_colors.dart';
import 'profile_home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmationController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmationController.dispose();
    super.dispose();
  }

  // Clean up the controller when the widget is removed from the
  // widget tree.

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        name: "Sign Up",
        leadingIcon: Ionicons.md_person,
        leadingName: "Profile",
      leadingScreen: Activity.Profile,
        leadingTarget: const ProfileHome(),
    hasFloating: false,
    body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(flex: 5),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter an email',
                labelText: 'Email',
              ),
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter a password',
                labelText: 'Password',
              ),
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value.length < 6) {
                  return 'Please enter a password that has at least 6 characters';
                }
                if (value != confirmationController.text) {
                  return 'Please enter same password';
                }

                return null;
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Confirm the password',
                labelText: 'Confirm password',
              ),
              controller: confirmationController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value.length < 6) {
                  return 'Please enter a password that has at least 6 characters';
                }
                if (value != passwordController.text) {
                  return 'Please enter same password';
                }

                return null;
              },
            ),
            Spacer(),
            CustomElevatedButton(
                  label: "Submit",
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      addUserAndClear();
                    }
                  }),
            Spacer(flex: 5),
          ],
        ),
      ),
    );
  }

  Future<void> addUserAndClear() async{
    await FirebaseApi.signUp(
        emailController.text, passwordController.text);
    FocusScope.of(context).unfocus();
    Common.showSnackBar(context, "New user correctly added !");
    emailController.clear();
    passwordController.clear();
    confirmationController.clear();
  }
}
