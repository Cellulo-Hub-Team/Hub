import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:process_run/shell.dart';
import '../game/game.dart';
import '../main/common.dart';

class ShellScripts{
  static Future<List<ProcessResult>> installGame(Game _game){
    if (Common.isWindows){
      return installGameWindows(_game);
    }
    return installGameWindows(_game);//TODO
  }

  //Installs the game on the hard drive on Windows
  static Future<List<ProcessResult>> installGameWindows(Game _game) async{
    var shell = Shell();
    shell.cd('');
    await shell.run('if not exist CelluloGames md CelluloGames');
    var shell2 = shell.cd('CelluloGames');
    await shell2.run('md ${_game.unityName}');
    var shell3 = shell2.cd(_game.unityName);
    await shell3.run('curl "${_game.windowsBuild}" --output ${_game.unityName}.zip'); // TODO add loading icon
    return shell3.run('tar -xf ${_game.unityName}.zip');
  }

  //Checks whether the game is on the hard drive on Windows
  static Future<bool> isInstalledWindows(Game _game) async{
    var shell = Shell();
    shell.cd('');
    await shell.run('if not exist CelluloGames md CelluloGames');
    var shell2 = shell.cd('CelluloGames');
    var result = await shell2.run('if exist ${_game.unityName} echo found');
    return result.outText.isNotEmpty;
  }

  //Launches the game from the hard drive on Windows
  static void launchGameWindows(Game _game) async{
    var shell = Shell();
    shell.cd('');
    var shell2 = shell.cd('CelluloGames');
    var shell3 = shell2.cd(_game.unityName);
    var shell4 = shell3.cd(_game.unityName);
    await shell4.run(_game.unityName);
  }

  //Deletes the game from the hard drive on Windows
  static Future<List<ProcessResult>> uninstallGameWindows(Game _game) async{
    var shell = Shell();
    shell.cd('');
    var shell2 = shell.cd('CelluloGames');
    return shell2.run('rmdir /Q /S ${_game.unityName}');
  }
}