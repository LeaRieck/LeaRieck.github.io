import 'Entity.dart';
import 'Level.dart';
import 'Player.dart';
import 'Position.dart';

///Wall limiting player movement///
class Wall extends Entity {
  ///Constructor for wall///
  Wall(Level l, Position pos) : super(l, pos, l.gridSize);

  @override
  void move() {
    // DO NOTHING
  }

  @override
  void collide(Player p) {
    var d = collideSquare(p);
    switch (d) {
      case 't':
        p.position.y = position.y - p.hitbox;
        break;
      case 'b':
        p.position.y = position.y + hitbox;
        break;
      case 'r':
        p.position.x = position.x + hitbox;
        break;
      case 'l':
        p.position.x = position.x - p.hitbox;
        break;
      default:
    }
  }

  @override
  void activate() {
    // TODO: implement activate
  }
}
