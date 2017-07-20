class Position {
  num x;
  num y;

  Position({this.x: 0, this.y: 0});

  Position.fromPoints(List<num> points)
      : x = points[0],
        y = points[1];

  Position operator +(Position p) => new Position(x: x + p.x, y: y + p.y);
  Position operator -(Position p) => new Position(x: x - p.x, y: y - p.y);

  String toString() => 'x: ${x}, y: ${y}';
}
