import 'dart:html';

import 'Entity.dart';
import 'Level.dart';
import 'Player.dart';
import 'Position.dart';

class Goal extends Entity {
  bool locked;

  Goal(Level level, Position position, double hitbox, this.locked)
      : super(level, position, hitbox);

  void open() {
    locked = false;
  }

  @override
  void collide(Player p) {
    if (locked) {
      switch (collideSquare(p)) {
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
    } else {
      if (p.position.equals(position)) {
        level.stopLevel(true);
      }
    }
  }

  @override
  void move() {
    // DO NOTHING
  }

  @override
  void activate() {
    // DO NOTHING
  }
}
