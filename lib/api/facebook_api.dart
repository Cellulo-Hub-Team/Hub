import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookApi{
  static FacebookAuth auth = FacebookAuth.instance;

  static bool loggedWithFacebook = false;

  static Future<bool> isLoggedIn() async{
    AccessToken? token = await auth.accessToken;
    return token != null;
  }

  static Future<void> logout() async{
    //No checks that someone is logged in because we assume that this function is only called
    // in a context where a user is logged in with Facebook
    await auth.logOut();
  }

  static Future<void> login() async{
    final LoginResult result = await auth.login(); // by default we request the email and the public profile
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken!;
    } else {
      print(result.status);
      print(result.message);
    }
  }
}