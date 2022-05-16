import 'package:cellulo_hub/main_desktop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../account/profile.dart';
import '../account/profile_home.dart';
import '../api/facebook_api.dart';
import '../api/firedart_api.dart';
import '../api/flutterfire_api.dart';
import '../custom_widgets/custom_colors.dart';
import '../custom_widgets/custom_elevated_button.dart';
import '../custom_widgets/custom_icon_button.dart';
import '../custom_widgets/custom_scaffold.dart';
import '../custom_widgets/style.dart';
import '../main.dart';
import 'common.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static bool _boolTheme = false;
  static bool _boolContrast = false;

  //Switches between day mode and night mode
  _switchTheme() {
    setState(() {
      Common.darkTheme = !Common.darkTheme;
      MyApp.themeNotifier.value = Common.darkTheme ? ThemeMode.dark : ThemeMode.light;
      MyAppDesktop.themeNotifier.value = Common.darkTheme ? ThemeMode.dark : ThemeMode.light;
      Common.showSnackBar(context,
          Common.darkTheme ? "Switched to Night mode" : "Switched to Day mode");
    });
  }

  //Switches between normal mode and high contrast mode
  _switchContrast() {
    setState(() {
      Common.contrastTheme = !Common.contrastTheme;
      CustomColors.currentColor = CustomColors.purpleColor();
      Common.showSnackBar(context,
          Common.darkTheme ? "Switched to High contrast mode" : "Switched to Normal contrast mode");
    });
  }

  //Disconnect user from the database
  _signOut() async {
    if (Common.isDesktop) {
      if (FiredartApi.isLoggedIn()) {
        FiredartApi.auth.signOut();
      }
    } else {
      if (FlutterfireApi.isLoggedIn()) {
        await FlutterfireApi.auth.signOut();
      } else if (FacebookApi.loggedWithFacebook) {
        await FacebookApi.logout();
        FacebookApi.loggedWithFacebook = false;
      }
    }
    Common.goToTarget(context, const ProfileHome(), false, Activity.Profile);
  }

  //Get user name or email depending on availability on the current platform
  Future<String> _getCurrentAuth() async {
    if (Common.isDesktop) {
      if (FiredartApi.isLoggedIn()) {
        var user = await FiredartApi.auth.getUser();
        return user.email!;
      }
      return 'No User';
    } else {
      if (FlutterfireApi.isLoggedIn()) {
        return (FlutterfireApi.auth.currentUser!.email)!;
      } else if (FacebookApi.loggedWithFacebook) {
        Map<String, dynamic> userData =
            await FacebookApi.auth.getUserData(fields: 'name,friends');
        print(userData['friends']);
        return userData['name'];
      }
    }
    return 'No User';
  }

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.purpleColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        name: "Settings",
        leadingIcon: Entypo.shop,
        leadingName: "Menu",
        leadingScreen: Activity.Menu,
        leadingTarget: const MainMenu(),
        hasFloating: false,
        body: Center(
            child: Column(children: [
      const Spacer(flex: 8),
      Text("Visual settings", style: Style.titleStyle()),
      const Spacer(flex: 4),
      Container(
          width: 300,
          child: Row(children: [
            SizedBox(width: 50),
            Transform.scale(
                scale: 1.5,
                child: Switch(
                  activeTrackColor: Colors.greenAccent,
                  thumbColor: MaterialStateProperty.all(Colors.white),
                  value: _boolTheme,
                  onChanged: (value) {
                    setState(() {
                      _boolTheme = value;
                      _switchTheme();
                    });
                  },
                )),
            Text("  Day/night theme", style: TextStyle(color: CustomColors.darkThemeColor())),
          ])),
      const Spacer(),
              Container(
                  width: 300,
                  child: Row(children: [
                    SizedBox(width: 50),
                    Transform.scale(
                        scale: 1.5,
                        child: Switch(
                          activeTrackColor: Colors.greenAccent,
                          thumbColor: MaterialStateProperty.all(Colors.white),
                          value: _boolContrast,
                          onChanged: (value) {
                            _boolContrast = value;
                            setState(() {
                              _switchContrast();
                            });
                          },
                        )),
                    Text("  High contrast theme", style: TextStyle(color: CustomColors.darkThemeColor())),
                  ])),
      const Spacer(flex: 4),
      Text("Profile settings", style: Style.titleStyle()),
      const Spacer(flex: 4),
      FutureBuilder(
        future: _getCurrentAuth(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) {
            // while data is loading:
            return const CircularProgressIndicator();
          } else {
            // data loaded:
            final output = snapshot.data;
            return Center(
              child: Text('Connected as: $output',
                  style: TextStyle(
                      fontSize: 18, color: CustomColors.darkThemeColor())),
            );
          }
        },
      ),
      const Spacer(),
      CustomElevatedButton(label: "Log out", onPressed: _signOut),
      const Spacer(flex: 8),
    ])));
  }
}
