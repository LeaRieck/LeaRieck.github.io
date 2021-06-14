import 'dart:html';
import 'dart:convert';

import 'Level.dart';

///Model of Escape The Dark///
class Game {
  //number of levels beaten
  int beatenLevel;
  //Map of JSON-files describing levels
  Map<int, String> JSONFiles;
  //Map of best times for levels
  Map<int, double> recordTimes;
  //Currently played level
  Level level;

  ///Constructor to create game model///
  Game() {
    beatenLevel = 0;
    JSONFiles = {};
    recordTimes = {};
    loadLevels();
  }

  ///Creates level from JSON-file///
  Future<void> generateLevel(int levelid) async {
    try {
      final JSON = await HttpRequest.getString(JSONFiles[levelid]);
      level = Level(0, JSON);
    } catch (ex) {
      print('Cannot generate level');
      print(ex);
    }
  }

  void loadLevels() async {
    final JSONObject = await HttpRequest.getString('../resources/level.json');
    Map JSON = jsonDecode(JSONObject);
    JSON.forEach((key, value) {
      int i = int.parse(key.substring(key.length - 1));
      JSONFiles[i] = value;
    });
  }
}
