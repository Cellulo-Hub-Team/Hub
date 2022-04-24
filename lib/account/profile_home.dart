import 'package:cellulo_hub/account/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../custom_widgets/custom_colors.dart';
import '../custom_widgets/custom_menu_button.dart';
import '../main/common.dart';
import 'login.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({Key? key}) : super(key: key);

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  @override
  void initState() {
    CustomColors.currentColor = CustomColors.purpleColor.shade900;
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
        onPressed: () => Common.goToTarget(context, const Login()),
      ),
      const Spacer(),
      CustomMenuButton(
        label: "Sign Up",
        icon: Entypo.shop,
        color: CustomColors.currentColor,
        onPressed: () => Common.goToTarget(context, const SignUp()),
      ),
      const Spacer(flex: 2),
    ])));
  }
}
