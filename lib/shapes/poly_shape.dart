part of smartcanvas;

abstract class PolyShape extends Node {
  BBox _bbox = null;
  List<Position> _points = null;

  PolyShape([Map<String, dynamic> config = const {}]) : super(config) {
    this
      ..on('translateXChanged translateYChanged', () => _bbox = null)
      ..on('pointsChanged', () {
      _bbox = null;
      _points = null;
    });
  }

  @override
  BBox getBBox(bool isAbsolute) {
    _getBBox();
    return new BBox(x: this.x, y: this.y, width: _bbox.width, height: _bbox.height);
  }

  void _getBBox() {
    if (_bbox == null) {
      var points = this.points;
      var minX = double.MAX_FINITE;
      var maxX = -double.MAX_FINITE;
      var minY = double.MAX_FINITE;
      var maxY = -double.MAX_FINITE;
      for (int i = 0; i < points.length; i++) {
        minX = min(minX, points[i].x);
        maxX = max(maxX, points[i].x);
        minY = min(minY, points[i].y);
        maxY = max(maxY, points[i].y);
      }
      var halfStrokeWidth = strokeWidth / 2 + 10;
      _bbox = new BBox(
        x: minX - halfStrokeWidth,
        y: minY - halfStrokeWidth,
        width: maxX - minX + strokeWidth + 20,
        height: maxY - minY + strokeWidth + 16
      );
    }
  }

  void set points(dynamic value);
  List<Position> get points;

  String get pointsString;

  @override
  num get x {
    _getBBox();
    return super.x + _bbox.x;
  }

  @override
  num get y {
    _getBBox();
    return super.y + _bbox.y;
  }

  @override
  num get width {
    _getBBox();
    return _bbox.width;
  }

  @override
  num get height {
    _getBBox();
    return _bbox.height;
  }

  Position get origin {
    return new Position(x: super.x, y: super.y);
  }
}
