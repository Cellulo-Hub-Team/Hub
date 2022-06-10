import 'dart:io';

import 'package:process_run/shell.dart';

import '../game/game.dart';
import '../main/common.dart';

class ShellScripts {
  static Future<List<ProcessResult>> installGame(Game _game) {
    if (Common.isWindows) {
      return installGameWindows(_game);
    }
    return installGameLinux(_game);
  }

  static Future<bool> isInstalled(Game _game) {
    if (Common.isWindows) {
      return isInstalledWindows(_game);
    }
    return isInstalledLinux(_game);
  }

  static void launchGame(Game _game) {
    if (Common.isWindows) {
      return launchGameWindows(_game);
    }
    return launchGameLinux(_game);
  }

  static Future<List<ProcessResult>> uninstallGame(Game _game) {
    if (Common.isWindows) {
      return uninstallGameWindows(_game);
    }
    return uninstallGameLinux(_game);
  }

  ///Installs the game on the hard drive on Windows
  static Future<List<ProcessResult>> installGameWindows(Game _game) async {
    var shell = Shell();
    shell.cd('');
    await shell.run('if not exist CelluloGames md CelluloGames');
    var shell2 = shell.cd('CelluloGames');
    await shell2.run('md ${_game.unityName}');
    var shell3 = shell2.cd(_game.unityName);
    await shell3.run(
        'curl "${_game.windowsBuild}" --output ${_game.unityName}.zip');
    return shell3.run('tar -xf ${_game.unityName}.zip');
  }

  ///Installs the game on the hard drive on Linux
  static Future<List<ProcessResult>> installGameLinux(Game _game) async {
    var shell = Shell();
    shell.cd('');
    await shell.run('mkdir -p CelluloGames');
    var shell2 = shell.cd('CelluloGames');
    await shell2.run('mkdir ${_game.unityName}');
    var shell3 = shell2.cd(_game.unityName);
    await shell3.run(
        'wget -O ${_game.unityName}.zip ${_game.linuxBuild}');
    return shell3.run('unzip ${_game.unityName}.zip');
  }

  ///Checks whether the game is on the hard drive on Windows
  static Future<bool> isInstalledWindows(Game _game) async {
    var shell = Shell();
    shell.cd('');
    await shell.run('if not exist CelluloGames md CelluloGames');
    var shell2 = shell.cd('CelluloGames');
    var result = await shell2.run('if exist ${_game.unityName} echo found');
    return result.outText.isNotEmpty;
  }

  ///Checks whether the game is on the hard drive on Linux
  static Future<bool> isInstalledLinux(Game _game) async {
    var shell = Shell();
    shell.cd('');
    await shell.run('mkdir -p CelluloGames');
    var shell2 = shell.cd('CelluloGames');
    var result = await shell2.run('test -d ${_game.unityName} && echo found');
    return result.outText.isNotEmpty;
  }

  ///Launches the game from the hard drive on Windows
  static void launchGameWindows(Game _game) async {
    var shell = Shell();
    shell.cd('');
    var shell2 = shell.cd('CelluloGames');
    var shell3 = shell2.cd(_game.unityName);
    var shell4 = shell3.cd(_game.unityName);
    await shell4.run(_game.unityName);
  }

  ///Launches the game from the hard drive on Linux
  static void launchGameLinux(Game _game) async {
    var shell = Shell();
    shell.cd('');
    var shell2 = shell.cd('CelluloGames');
    var shell3 = shell2.cd(_game.unityName);
    await shell3.run("chmod +x ${_game.unityName}.x86_64");
    await shell3.run("./${_game.unityName}.x86_64");
  }

  ///Deletes the game from the hard drive on Windows
  static Future<List<ProcessResult>> uninstallGameWindows(Game _game) async {
    var shell = Shell();
    shell.cd('');
    var shell2 = shell.cd('CelluloGames');
    return shell2.run('rmdir /Q /S ${_game.unityName}');
  }

  ///Deletes the game from the hard drive on Linux
  static Future<List<ProcessResult>> uninstallGameLinux(Game _game) async {
    var shell = Shell();
    shell.cd('');
    var shell2 = shell.cd('CelluloGames');
    return shell2.run('rm -r ${_game.unityName}');
  }
}
