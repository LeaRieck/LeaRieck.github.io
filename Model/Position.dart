///Helper class for position of entities///
class Position<E> extends Object {
  double x;
  double y;

  ///Constructor for Position///
  Position(this.x, this.y);

  ///Shift position by dx and dy///
  Position move(double dx, double dy) {
    this.x += dx;
    this.y += dy;
    return this;
  }

  Position change(double x, double y) {
    this.x = x;
    this.y = y;
    return this;
  }

  bool equals(Position other) {
    return x == other.x && y == other.y;
  }

  @override
  bool operator ==(Object other) {
    if (other is Position) {
      return x == other.x && y == other.y;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
  @override
  String toString() {
    return '[$x,$y]';
  }
}
