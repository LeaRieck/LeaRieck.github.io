import 'dart:math';

import 'Level.dart';
import 'Player.dart';
import 'Position.dart';

///Abstract entity class representing objects in level///
abstract class Entity extends Object {
  //Level the entity exists in
  Level level;
  //Position of entity
  Position position;
  //Size of entity
  double hitbox;

  ///Constructor to create entity///
  Entity(this.level, this.position, this.hitbox);

  ///Activate Entity///
  void activate();

  ///Move entity by dx and dy///
  void move();

  ///Method to handle collision with player///
  void collide(Player p);

  String collideSquare(Player p) {
    var circleDistance_x = (p.position.x) - (position.x);
    var circleDistance_y = (p.position.y) - (position.y);
    //distance between center of entity to center of player is less than half of entity-size + player radius
    if (!(circleDistance_x.abs() > (hitbox / 2 + p.hitbox / 2)) &&
        !(circleDistance_y.abs() > (hitbox / 2 + p.hitbox / 2))) {
      //player collides with entity and center of player is horizontally between entity boundaries
      if (circleDistance_x.abs() <= (hitbox / 2) &&
          circleDistance_y.abs() <= (hitbox / 2 + p.hitbox / 2)) {
        //player collided with entity from below
        if (circleDistance_y > 0) {
          return 'b';
        }
        //player collided with entity from above
        else {
          return 't';
        }
      }
      //player collides with entity and center of player is vertically between entity boundaries
      if (circleDistance_x.abs() <= (hitbox / 2 + p.hitbox / 2) &&
          circleDistance_y.abs() <= (hitbox / 2)) {
        //player collided with entity from right side
        if (circleDistance_x > 0) {
          return 'r';
        }
        //player collided with entity from left side
        else {
          return 'l';
        }
      }
      //player collided with corner of entity
      if (pow(circleDistance_x.abs() - hitbox / 2, 2) +
              pow(circleDistance_y.abs() - hitbox / 2, 2) <=
          (pow(p.hitbox / 2, 2))) {
        //distance between player center and entity center is farthest in vertical direction
        if (circleDistance_x.abs() > circleDistance_y.abs()) {
          if (circleDistance_x > 0) {
            return 'r';
          } else {
            return 'l';
          }
        }
        //distance between player center and entity center is farthest in horizontal direction
        else {
          if (circleDistance_y > 0) {
            return 'b';
          } else {
            return 't';
          }
        }
      }
    }
    return 'none';
  }

  bool collideCircle(Player p) {
    return (pow((p.position.x + p.hitbox / 2) - (position.x + hitbox / 2), 2) +
            pow((p.position.y + p.hitbox / 2) - (position.y + hitbox / 2), 2) <
        pow(p.hitbox / 2 + hitbox / 2, 2));
  }
}
