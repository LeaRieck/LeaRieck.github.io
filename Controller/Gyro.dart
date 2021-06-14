import 'dart:html';
import 'dart:math';

import '../Model/Game.dart';
import 'EventHandler.dart';

///Device orientation based event handler///
class Gyro extends EventHandler {
  ///Constructor for device orientation based event handler///
  Gyro(Game g) : super(g) {
    window.onDeviceOrientation.listen(handle);
  }

  ///Method that handles device orientation events///
  @override
  void handle(Event ev) async {
    if (ev is DeviceOrientationEvent) {
      if (ev.alpha != null && ev.beta != null && ev.gamma != null) {
        final dy = min(50, max(10, ev.beta)) - 30 <= 0
            ? min(50, max(10, ev.beta)) - 30 == 0
                ? 0.0
                : -1.0
            : 1.0;
        final dx = min(20, max(-20, ev.gamma)) <= 0
            ? min(20, max(-20, ev.gamma)) == 0
                ? 0.0
                : -1.0
            : 1.0;
        // game.level.player.move(dx, dy);
        if(dx == 0.0) {
          game.level.player.directions['left'] = 0;
          game.level.player.directions['right'] = 0;
        }
        if(dx == -1) {
          game.level.player.directions['left'] = -1;
          game.level.player.directions['right'] = 0;
        }
        if(dx == 1) {
          game.level.player.directions['left'] = 0;
          game.level.player.directions['right'] = -1;
        }
        if(dy == 0.0) {
          game.level.player.directions['up'] = 0;
          game.level.player.directions['down'] = 0;
        }
        if(dy == -1) {
          game.level.player.directions['up'] = -1;
          game.level.player.directions['down'] = 0;
        }
        if(dy == 1) {
          game.level.player.directions['up'] = 0;
          game.level.player.directions['down'] = -1;
        }
      }
    }
  }
}
