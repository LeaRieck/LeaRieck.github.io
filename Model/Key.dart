import 'Entity.dart';
import 'Level.dart';

import 'Player.dart';
import 'Position.dart';

class Key extends Entity {
  Key(Level l, Position p, double hitbox) : super(l, p, hitbox);

  @override
  void activate() {
    level.goal.open();
  }

  @override
  void collide(Player p) {
    if (collideCircle(p)) activate();
  }

  @override
  void move() {
    // DO NOTHING
  }
}
