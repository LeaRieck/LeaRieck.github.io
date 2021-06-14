import '../Model/Game.dart';
import '../View/View.dart';
import 'dart:html';
import 'dart:async';

import 'EventHandler.dart';

///Controller for Escape The Dark///
class Controller {
  //Reference to the controlled model
  Game game;
  //Reference to the view that represents the model
  View view;
  //Reference to the registered event handler
  EventHandler eventHandler;

  ///Constructor to create the Controller///
  Controller(this.view, this.game) {
    observeMenu();
  }

  ///Sets size of Elements///
  void setGameSize() {}

  //Observe Menu Buttons
  void observeMenu() async {
    querySelector('#PlayButton').onClick.listen((ev) {
      view.generateLevelOverview();
      querySelectorAll('.levelButton').onClick.listen((ev) async {
        var s = (ev.target as Element).innerHtml;
        await view.generateLevel(int.parse(s.substring(s.length - 1)));
        observeEvents();
      });
    });
  }

  ///Starts the Controller. This method registers all necessary event handlers.///
  void observeEvents() async {
    eventHandler = await EventHandler(game).createEventHandler();
    while (!game.level.finished && !game.level.gameOver) {
      view.update();
      await Future.delayed(const Duration(milliseconds: 50));
    }
    view.update();
  }
}
