part of smartcanvas;

class Polygon extends Node {
  BBox _bbox = null;
  List<Position> _points = null;

  Polygon([Map<String, dynamic> config = const {}]) : super(config) {
    this
      ..on('translateXChanged translateYChanged', () => _bbox = null)
      ..on('pointsChanged', () {
      _bbox = null;
      _points = null;
    });
  }

  @override
  Node _clone(Map<String, dynamic> config) => new Polygon(config);

  @override
  NodeImpl _createSvgImpl([bool isReflection = false]) =>
    new SvgPolygon(this, isReflection);

  @override
  NodeImpl _createCanvasImpl() => new CanvasPolygon(this);

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
      var halfStrokeWidth = strokeWidth / 2;
      _bbox = new BBox(x: minX - halfStrokeWidth, y: minY - halfStrokeWidth,
      width: maxX - minX + strokeWidth, height: maxY - minY + strokeWidth);
    }
  }

  void set points(dynamic value) {
    if (value is String) {
      setAttribute(POINTS, value);
    } else if (value is List) {
      if (value.isNotEmpty) {
        if (value.first is num) {
          setAttribute(POINTS, value);
        } else if (value.first is Position) {
          var ps = [];
          value.forEach((Position p) {
            ps.add(p.x);
            ps.add(p.y);
          });
          setAttribute(POINTS, ps);
        } else {
          throw new Exception('Invalid parameter');
        }
      } else {
        setAttribute(POINTS, []);
      }
    } else {
      throw new Exception('Invalid parameter');
    }
  }

  List<Position> get points {
    if (_points == null) {
      _points = [];
      var ps = getAttribute(POINTS);
      if (ps != null) {
        if (ps is String) {
          var pss = ps.split(comma);
          for (int i = 0; i < pss.length; i += 2) {
            _points.add(new Position(x: num.parse(pss[i]), y: num.parse(pss[i + 1])));
          }
        } else if (ps is List) {
          if (ps.isNotEmpty) {
            if (ps.first is num) {
              for (int i = 0; i < ps.length; i += 2) {
                _points.add(new Position(x: ps[i], y: ps[i + 1]));
              }
            }
          } else {
            _points.addAll(ps);
          }
        }
      }
    }
    return _points;
  }

  String get pointsString => getAttribute(POINTS, '');

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
}
