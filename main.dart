import 'dart:html';
import 'dart:async';
import 'Controller/Controller.dart';
import 'Model/Game.dart';
import 'View/View.dart';

void main() {
  Game game = Game();
  View view = View(game);
  Controller controller = Controller(view, game);
}
