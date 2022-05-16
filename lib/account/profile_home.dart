import 'package:cellulo_hub/account/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../api/facebook_api.dart';
import '../custom_widgets/custom_colors.dart';
import '../custom_widgets/custom_menu_button.dart';
import '../main.dart';
import '../main/common.dart';
import 'sign_in.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({Key? key}) : super(key: key);

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {

  ///Launch the facebook authentication page
  _onPressedFacebook() async {
    if (await FacebookApi.isLoggedIn()) {
      FacebookApi.loggedWithFacebook = true;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainMenu()));
      AccessToken? token = await FacebookApi.auth.accessToken;
      print(token!.userId);
      final snackBar = Common.showSnackBar(
          context, "You're already logged in with facebook");
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Future.delayed(const Duration(seconds: 6),
          () => ScaffoldMessenger.of(context).hideCurrentSnackBar());
    } else {
      final LoginResult result = await FacebookAuth.instance
          .login(); // By default we request the email and the public profile
      if (result.status == LoginStatus.success) {
        // You are logged in
        final AccessToken accessToken = result.accessToken!;
        FacebookApi.loggedWithFacebook = true;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainMenu()));
      } else { }//TODO
    }
  }

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.purpleColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: [
      const Spacer(flex: 2),
      CustomMenuButton(
        label: "Login",
        icon: Ionicons.md_key,
        color: CustomColors.currentColor,
        onPressed: () => Common.goToTarget(
            context, const SignIn(), true, Common.currentScreen),
      ),
      const Spacer(),
      CustomMenuButton(
        label: "Sign Up",
        icon: MaterialCommunityIcons.account_plus,
        color: CustomColors.currentColor,
        onPressed: () => Common.goToTarget(
            context, const SignUp(), true, Common.currentScreen),
      ),
      Common.isDesktop ? Container() : const Spacer(),
      Common.isDesktop
          ? Container()
          : CustomMenuButton(
              label: "Login with Facebook",
              icon: Entypo.facebook,
              color: CustomColors.currentColor,
              onPressed: () => _onPressedFacebook(),
            ),
      const Spacer(flex: 2),
    ])));
  }
}
