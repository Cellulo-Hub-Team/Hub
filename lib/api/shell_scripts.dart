import 'package:process_run/shell.dart';
import '../game/game.dart';
import '../main/common.dart';

class ShellScripts{
  static void installGame(Game _game){
    if (Common.isWindows){
      installGameWindows(_game);
    }
    else if (Common.isLinux){
      installGameWindows(_game);//TODO
    }
  }

  static void installGameWindows(Game _game) async{
    var shell = Shell();
    shell.cd('');
    await shell.run('md CelluloGames');
    var shell2 = shell.cd('CelluloGames');
    await shell2.run('md ${_game.name}');
    var shell3 = shell2.cd(_game.name);
    await shell3.run('curl "${_game.windowsBuild}" --output build.zip');
    await shell3.run('tar -xf build.zip');
  }

  static void launchGameWindows(Game _game) async{
    var shell = Shell();
    shell.cd('');
    var shell2 = shell.cd('CelluloGames');
    var shell3 = shell2.cd(_game.name);
    var shell4 = shell3.cd('build');
    await shell4.run(_game.name);
  }
}