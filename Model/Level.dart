import 'dart:convert';

import 'Abyss.dart';
import 'Entity.dart';
import 'Goal.dart';
import 'Player.dart';
import 'Position.dart';

import 'Wall.dart';

///Level of Escape the Dark///
class Level {
  //Identification number of level
  int levelID;
  //Name of level
  String name;
  //Time level is running
  int time;
  Stopwatch watch;
  //Width of level
  double width;
  //Height of level
  double height;
  //Is player dead?
  bool gameOver;
  //Did player finish this level?
  bool finished;
  //Size of grid
  double gridSize = 50.0;
  //Player
  Player player;
  //Goal
  Goal goal;
  //List of entities forming the level
  List<Entity> entities;
  //Points the player can respawn at
  Map<int, Position> checkpoints;

  ///Contructor to create level///
  Level(this.levelID, String JSONObject) {
    entities = [];
    generateLabyrinth(JSONObject);
    watch = Stopwatch();
    gameOver = false;
    finished = false;
    startLevel();
  }

  ///Generate Labyrinth from JSON-String by creating entities
  void generateLabyrinth(String JSONObject) {
    Map JSON = jsonDecode(JSONObject);
    width = JSON['Level'].values.elementAt(0).length * gridSize;
    height = JSON['Level'].length * gridSize;

    double y = gridSize / 2; //Counter variable for Rows
    double x = gridSize / 2; //Counter variable for Columns

    JSON['Level'].forEach((row, columns) {
      x = gridSize / 2;
      columns.forEach((element) {
        if (element == 'Wall') {
          entities.add(Wall(this, Position(x, y)));
        }
        if (element == 'Goal') {
          goal = Goal(this, Position(x, y), gridSize, JSON['GoalLocked']);
        }
        if (element == 'Start') {
          player = Player(this,
              Position(x - (gridSize / 2), y - (gridSize / 2)), gridSize, 2, 1);
        }
        if(element == 'Abyss') {
          entities.add(Abyss(this, Position(x, y)));
        }
        x = x + gridSize;
      });
      y = y + gridSize;
    });
    player.lookaround();
  }

  void startLevel() {
    watch.start();
  }

  void stopLevel(bool result) {
    if (result) {
      finished = true;
    } else {
      gameOver = true;
    }
    watch.stop();
    time = watch.elapsedMilliseconds;
  }
}
