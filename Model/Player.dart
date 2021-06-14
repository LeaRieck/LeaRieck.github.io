import 'Entity.dart';
import 'Level.dart';
import 'Position.dart';
import 'Wall.dart';

///Player entity///
class Player extends Entity {
  //Is player alive?
  bool alive = true;
  //Viewing range of player
  int viewRange;
  //Speed multiplier - steplength of player
  Set viewPath;
  Set discoveredPath;
  double speed;
  var directions = {'left':0.0, 'right':0.0, 'up':0.0, 'down': 0.0};

  ///Constructor for Player///
  Player(Level level, Position pos, double hitbox, this.viewRange, this.speed)
      : super(level, pos.move(hitbox / 2, hitbox / 2), hitbox) {
    viewPath = <Position>{};
    discoveredPath = <Position>{};
        move();
      }

  ///Move player by dx and dy///
  @override
  void move() async{
    while(alive) {
      var dx = 0.0;
      var dy = 0.0;
      directions.forEach((key, value) {
        if(value.round() != 0) {
          switch(key) {
            case 'left':
              dx-=1;
              break;
            case 'right':
              dx+=1;
              break;
            case 'up':
              dy-=1;
              break;
            case 'down':
              dy+=1;
              break;
          }
          if(value>0) {
            directions[key] = value-(1/speed);
          }
        }
      });
      position.move(dx, dy);
      if (position.x > level.width - hitbox / 2) {
        position.x = level.width - hitbox / 2;
      }
      if (position.x < (hitbox / 2)) {
        position.x = (hitbox / 2);
      }
      if (position.y > level.height - hitbox / 2) {
        position.y = level.height - hitbox / 2;
      }
      if (position.y < (hitbox / 2)) {
        position.y = (hitbox / 2);
      }
      collisionObserve();
      lookaround();
      await Future.delayed( Duration(milliseconds: ((6/speed).round())));
    }
  }

  void collisionObserve() {
    for (Entity e in level.entities) {
      e.collide(this);
    }
    level?.goal?.collide(this);
  }

  @override
  void collide(Player p) {
    // DO NOTHING
  }

  @override
  void activate() {
    // DO NOTHING
  }

  //Compute the Viewfield of the player
  void lookaround() async {
    viewPath = <Position>{};
    addGrid(0, 0);
    var posrangepos = viewRange;
    var posrangeneg = viewRange;
    var negrangepos = viewRange;
    var negrangeneg = viewRange;
    var poswall = false;
    var negwall = false;
    for (var i = 1; i <= viewRange; i++) {
      if (!poswall) {
        for (var j = 1; j <= posrangepos; j++) {
          if (addGrid(i, j)) {
            posrangepos = j;
            break;
          }
        }
        for (var j = 1; j <= posrangeneg; j++) {
          if (addGrid(i, -j)) {
            posrangeneg = j;
            break;
          }
        }
        poswall = addGrid(i, 0);
      }
      if (!negwall) {
        for (var j = 1; j <= negrangepos; j++) {
          if (addGrid(-i, j)) {
            negrangepos = j;
            break;
          }
        }
        for (var j = 1; j <= negrangeneg; j++) {
          if (addGrid(-i, -j)) {
            negrangeneg = j;
            break;
          }
        }
        negwall = addGrid(-i, 0);
      }
    }
    posrangepos = viewRange;
    posrangeneg = viewRange;
    negrangepos = viewRange;
    negrangeneg = viewRange;
    poswall = false;
    negwall = false;
    for (var i = 1; i <= viewRange; i++) {
      if (!poswall) {
        for (var j = 1; j <= posrangepos; j++) {
          if (addGrid(j, i)) {
            posrangepos = j;
            break;
          }
        }
        for (var j = 1; j <= posrangeneg; j++) {
          if (addGrid(-j, i)) {
            posrangeneg = j;
            break;
          }
        }
        poswall = addGrid(0, i);
      }
      if (!negwall) {
        for (var j = 1; j <= negrangepos; j++) {
          if (addGrid(j, -i)) {
            negrangepos = j;
            break;
          }
        }
        for (var j = 1; j <= negrangeneg; j++) {
          if (addGrid(-j, -i)) {
            negrangeneg = j;
            break;
          }
        }
        negwall = addGrid(0, -i);
      }
    }
  }

  Position getPlayerGrid() {
    var axis = (num axis) =>
        (((axis - level.gridSize / 2) / level.gridSize).round() *
            level.gridSize) +
        level.gridSize / 2;
    return Position(axis(position.x), axis(position.y));
  }

  bool addGrid(num x, num y) {
    var gridPos = getPlayerGrid();
    var grid_dy = gridPos.y + y * level.gridSize;
    var grid_dx = gridPos.x + x * level.gridSize;
    if (grid_dy < 0 ||
        grid_dy > level.height ||
        grid_dx < 0 ||
        grid_dx > level.width) return false;
    var pos = Position(grid_dx, grid_dy);
    viewPath.add(pos);
    discoveredPath.add(pos);
    return level.entities.any((element) {
      return (element.position == pos &&
          element is Wall);
    });
  }
}
