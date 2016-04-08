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
    var pos = isAbsolute ? absolutePosition : position;
    return new BBox(
      x: pos.x + _bbox.x,
      y: pos.y + _bbox.y,
      width: _bbox.width * actualScaleX,
      height: _bbox.height * actualScaleY
    );
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
      _bbox = new BBox(
        x: minX,
        y: minY,
        width: maxX - minX,
        height: maxY - minY
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
