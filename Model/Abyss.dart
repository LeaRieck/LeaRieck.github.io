import 'Level.dart';
import 'Player.dart';
import 'Position.dart';
import 'Trap.dart';

///Wall limiting player movement///
class Abyss extends Trap {
  ///Constructor for abyss///
  Abyss(Level l, Position pos) : super(l, pos, l.gridSize,true, 0.0, 0.0);

  @override
  void collide(Player p) {
    var d = collideSquare(p);
    if(d == 'collision') {
      level.player.alive = false;
      level.stopLevel(false);
    }
  }

  @override
  String collideSquare(Player p) {
    var circleDistance_x = (p.position.x) - (position.x);
    var circleDistance_y = (p.position.y) - (position.y);
    if(circleDistance_x.abs() <= hitbox/2 && circleDistance_y.abs() <=hitbox/2) {
      return 'collision';
    }
    return 'none';
    }
}
