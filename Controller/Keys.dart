import 'dart:html';

import '../Model/Game.dart';
import 'EventHandler.dart';

///Event handler for Keyboard///
class Keys extends EventHandler {
  //Number of steps the player makes after releasing key
  var lag;

  ///Constructor to create key based event handler///
  Keys(Game g) : super(g) {
    final controls = [KeyCode.UP, KeyCode.DOWN, KeyCode.LEFT, KeyCode.RIGHT];
    window.onKeyDown
        .where((event) => controls.contains(event.keyCode))
        .listen(handle);
    window.onKeyUp
        .where((event) => controls.contains(event.keyCode))
        .listen(delay);
        lag = game.level.gridSize;
  }

  ///Method that handles key input events///
  @override
  Future<void> handle(Event ev) async {
    if (ev is KeyboardEvent) {
      if (ev.keyCode == KeyCode.UP) {
        game.level?.player?.directions['up'] = -1;
      }
      if (ev.keyCode == KeyCode.DOWN) {
        game.level?.player?.directions['down'] = -1;
      }
      if (ev.keyCode == KeyCode.LEFT) {
        game.level?.player?.directions['left'] = -1;
      }
      if (ev.keyCode==KeyCode.RIGHT) {
        game.level?.player?.directions['right'] = -1;
      }
    }
  }

  ///Method that lets player move for lag steps after key is released///
  void delay(Event ev) async {
    if (ev is KeyboardEvent) {
      if (ev.keyCode == KeyCode.UP) {
        game.level?.player?.directions['up'] = lag;
      }
      if (ev.keyCode == KeyCode.DOWN) {
        game.level?.player?.directions['down'] = lag;
      }
      if (ev.keyCode == KeyCode.LEFT) {
        game.level?.player?.directions['left'] = lag;
      }
      if (ev.keyCode==KeyCode.RIGHT) {
        game.level?.player?.directions['right'] = lag;
      }
    }
  }
}
