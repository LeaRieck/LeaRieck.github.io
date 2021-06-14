import 'dart:async';
import 'dart:html';
import 'dart:html_common';

import '../Model/Abyss.dart';
import '../Model/Entity.dart';
import '../Model/Game.dart';
import 'dart:async';

import '../Model/Position.dart';
import '../Model/Wall.dart';

class View {
  Game game;
  final test = querySelector('.levelBackground');
  final player = querySelector('#player');
  final field = querySelector('#field');
  final camera = querySelector('#camera');
  final startMenu = querySelector('#startMenu');
  final levelOverview = querySelector('#levelOverview');
  final viewfield = querySelector('#viewfield');
  final iosButton = querySelector('#iosButton');
  var goalDiv;
  bool ios =
      Device.userAgent.contains('iPhone') || Device.userAgent.contains('iPad');

  //Multiplier for view size based on device
  double sizeMultiplier = 1;

  View(Game g) {
    game = g;
    generateMenu();
  }

  //Generate Menu
  void generateMenu() {
    var playButton = ButtonElement();
    playButton.className = 'menuButton';
    playButton.id = 'PlayButton';
    playButton.text = 'PLAY';
    startMenu.children.add(playButton);
  }

  void generateLevelOverview() {
    startMenu.style.display = 'none';
    levelOverview.style.display = 'flex';

    for (int i in game.JSONFiles.keys) {
      var levelButton = ButtonElement();
      String text = 'Level ' + i.toString();
      levelButton.classes.add('menuButton');
      levelButton.classes.add('levelButton');
      levelButton.id = text;
      levelButton.text = text;
      levelOverview.children.add(levelButton);
    }
  }

  //Create Level
  void generateLevel(int levelid) async {
    await game.generateLevel(levelid);

    levelOverview.style.display = 'none';
    camera.style.display = 'flex';

    (document.styleSheets[0] as CssStyleSheet).addRule(
        '.gridfield',
        'width: ${game.level.width.toString()}px; '
            'height: ${game.level.height.toString()}px;'
            'grid-template-rows: repeat(auto-fit, ${game.level.gridSize}px);'
            'grid-template-columns: repeat(auto-fit, ${game.level.gridSize}px);');
    // Set the button for iOS devices visible to get the permission to use the sensors
    if (ios) {
      iosButton.style.display = 'inline';
    }

    //Set player size
    player.style.width = '${game.level.player.hitbox}px';
    player.style.height = '${game.level.player.hitbox}px';

    //Build Level
    for (var y = game.level.gridSize / 2;
        y < game.level.height;
        y = y + game.level.gridSize) {
      for (var x = game.level.gridSize / 2;
          x < game.level.width;
          x = x + game.level.gridSize) {
        var fieldDiv = DivElement();
        var viewDiv = DivElement();
        fieldDiv.id = 'x$x-y$y';
        fieldDiv.classes.add('path');
        field.children.add(fieldDiv);
        viewDiv.id = 'v-' + fieldDiv.id;
        viewDiv.classes.add('viewblock');
        viewfield.children.add(viewDiv);
      }
    }

    //Create Entities
    for (Entity e in game.level.entities) {
      if (e is Wall) {
        final div = querySelector('#x${e.position.x}-y${e.position.y}');
        div.className = 'wall';
      }
      if(e is Abyss) {
        final div = querySelector('#x${e.position.x}-y${e.position.y}');
        div.className = 'abyss';
      }
    }
    //Create Goal
    goalDiv = querySelector(
        '#x${game.level.goal.position.x}-y${game.level.goal.position.y}');
  }

  Future<void> update() async {
    if (game.level.gameOver || game.level.finished) {
      var s = game.level.gameOver ? 'Du hast verloren\n' : 'Du hast gewonnen\n';
      window.alert(s + 'Du hast ${game.level.time / 1000} Sekunden gebraucht');
    } else {
      updateViewField();
      movePlayer();
      if (game.level.goal.locked) {
        goalDiv.className = 'goal_locked';
      } else {
        goalDiv.className = 'goal_unlocked';
      }
    }
  }

  void updateViewField() {
    DivElement div;
    var viewPositions = game.level.player.viewPath;
    var discoverdPositions = game.level.player.discoveredPath;
    for (Position pos in viewPositions) {
      div = querySelector('#v-x${pos.x}-y${pos.y}');
      if (!div.classes.contains('fadeout')) {}
      if (div.classes.contains('fadein')) {
        div.classes.remove('fadein');
        div.classes.add('halffadeout');
      } else {
        div.classes.add('fadeout');
      }
    }
    for (Position pos in discoverdPositions.difference(viewPositions)) {
      div = querySelector('#v-x${pos.x}-y${pos.y}');
      if (div.classes.contains('fadeout')) {
        div.classes.remove('fadeout');
      }
      div.classes.add('fadein');
    }
  }

  ///Method to shift elements based on player location//
  void movePlayer() {
    //determine movement of player
    var x = player.offsetLeft;
    var y = player.offsetTop;
    var dx = game.level.player.position.x - game.level.player.hitbox / 2 - x;
    var dy = game.level.player.position.y - game.level.player.hitbox / 2 - y;
    //move player inside field
    player.style.left =
        '${((game.level.player.position.x - game.level.player.hitbox / 2) * sizeMultiplier).toInt()}px';
    player.style.top =
        '${((game.level.player.position.y - game.level.player.hitbox / 2) * sizeMultiplier).toInt()}px';
    //shift field position inside camera
    field.style.left =
        '${(-game.level.player.position.x * sizeMultiplier + (camera?.getBoundingClientRect()?.width ?? 0.0) / 2).toInt()}px';
    field.style.top =
        '${(-game.level.player.position.y * sizeMultiplier + (camera?.getBoundingClientRect()?.height ?? 0.0) / 2).toInt()}px';
    viewfield.style.left = field.style.left;
    viewfield.style.top = field.style.top;
    test.style.left = field.style.left;
    test.style.top = field.style.top;
    //rotate player based on movement
    if (dx != 0 || dy != 0) {
      if (dx.abs() > dy.abs()) {
        if (dx >= 0) {
          player.style.transform = 'rotate(90deg)';
        } else {
          player.style.transform = 'rotate(270deg)';
        }
      } else {
        if (dy >= 0) {
          player.style.transform = 'rotate(180deg)';
        } else {
          player.style.transform = 'rotate(0deg)';
        }
      }
    }
  }
}
