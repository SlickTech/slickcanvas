part of smartcanvas;

class Position {
  num x;
  num y;

  Position({x: 0, y: 0}) {
    this.x = x;
    this.y = y;
  }

  Position operator + (Position p) => new Position(x: x + p.x, y: y + p.y);

  Position operator - (Position p) => new Position(x: x - p.x, y: y - p.y);

  String toString() => '${x}, ${y}';
}
