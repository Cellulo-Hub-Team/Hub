import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../api/firebase_api.dart';
import '../main/common.dart';
import '../main/custom_colors.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.currentColor,
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: Icon(Ionicons.md_person),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
            Align(
              child: ElevatedButton(
                style: Common.elevatedColorStyle(),
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    addUserAndClear();
                  }
                },
                child: const Text('Submit'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> addUserAndClear() async{
    await FirebaseApi.signUp(
        emailController.text, passwordController.text);
    FocusScope.of(context).unfocus();
    final snackBar = Common.checkSnackBar("New user correctly added !");
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Future.delayed(const Duration(seconds: 6),
            () => ScaffoldMessenger.of(context).hideCurrentSnackBar());
    emailController.clear();
    passwordController.clear();
    confirmationController.clear();
  }
}
