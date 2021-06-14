import 'Entity.dart';
import 'Level.dart';
import 'Player.dart';
import 'Position.dart';

///Wall limiting player movement///
class Trap extends Entity {
  bool active;
  double activeTime;
  double offTime;
  ///Constructor for wall///
  Trap(Level l, Position pos, double hitbox, this.active, this.activeTime, this.offTime) : super(l, pos, l.gridSize);

  @override
  void activate() {
    // TODO: implement activate
  }

  void deactivate() {

  }

  @override
  void move() {
    // DO NOTHING
  }

  @override
  void collide(Player p) {

  }


}
