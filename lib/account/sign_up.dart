import 'package:cellulo_hub/api/firedart_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../api/flutterfire_api.dart';
import '../custom_widgets/custom_colors.dart';
import '../custom_widgets/custom_elevated_button.dart';
import '../custom_widgets/custom_scaffold.dart';
import '../main/common.dart';
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

  ///Register new user to the database and clear input fields
  Future<void> addUserAndClear() async {
    if (Common.isDesktop) {
      await FiredartApi.signUp(emailController.text, passwordController.text);
    } else {
      await FlutterfireApi.signUp(
          emailController.text, passwordController.text, context);
    }
    FocusScope.of(context).unfocus();
    Common.showSnackBar(context, "New user correctly added !");
    emailController.clear();
    passwordController.clear();
    confirmationController.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmationController.dispose();
    super.dispose();
  }

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
            child: Center(
              child: SizedBox(
                width: 800,
                child: Column(
                  //TODO max width of 1000
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(flex: 5),
                    TextFormField(
                      cursorColor: CustomColors.darkThemeColor(),
                      style: TextStyle(color: CustomColors.darkThemeColor()),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter an email',
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.mail,
                            color: CustomColors.darkThemeColor()),
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
                      cursorColor: CustomColors.darkThemeColor(),
                      style: TextStyle(color: CustomColors.darkThemeColor()),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter a password',
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock,
                            color: CustomColors.darkThemeColor()),
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
                      cursorColor: CustomColors.darkThemeColor(),
                      style: TextStyle(color: CustomColors.darkThemeColor()),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm the password',
                        labelText: 'Confirm password',
                        prefixIcon: Icon(Icons.lock,
                            color: CustomColors.darkThemeColor()),
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
                    const Spacer(),
                    CustomElevatedButton(
                        label: "Submit",
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            addUserAndClear();
                          }
                        }),
                    const Spacer(flex: 5),
                  ],
                ),
              ),
            )));
  }
}
