import 'dart:html';

import '../Model/Game.dart';
import 'Gyro.dart';
import 'Keys.dart';


///Event handler for Escape The Dark///
class EventHandler {
  //Reference to the controlled model
  Game game;
  EventHandler eh;

  ///Constructor to create event handler
  EventHandler(this.game);

  ///Abstract factory method for creating event handler for current device///
  Future<EventHandler> createEventHandler() async{
    EventHandler ev = new Gyro(game);
     var device = window.onDeviceOrientation.listen((ev) {
      if (!(ev.alpha == null && ev.beta == null && ev.gamma == null)) {
          if(eh == null) {
            eh = new Gyro(game);
            return eh;
        }
      }
    });
    return new Keys(game);
  }

  ///Method that handles events///
  void handle(Event ev) {}
}
