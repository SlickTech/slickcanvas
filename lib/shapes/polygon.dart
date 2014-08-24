part of smartcanvas;

class Polygon extends Node{
  BBox _bbox = null;
  List<Position> _points = null;

  Polygon(Map<String, dynamic> config): super(config) {
    this.on('translateXChanged translateXChanged', () => _bbox = null);
    this.on('pointsChanged', () { _bbox = null; _points = null; });
  }

  NodeImpl _createSvgImpl(bool isReflection) {
    return new SvgPolygon(this, isReflection);
  }

  NodeImpl _createCanvasImpl() {
    return new CanvasPolygon(this);
  }

  BBox getBBox(bool isAbsolute) {
    _getBBox();
    return new BBox(x: this.x, y: this.y, width: _bbox.width, height: _bbox.height);
  }

  void _getBBox() {
    if (_bbox == null) {
      List<Position> points = this.points;
      num minX = double.MAX_FINITE;
      num maxX = -double.MAX_FINITE;
      num minY = double.MAX_FINITE;
      num maxY = -double.MAX_FINITE;
      for(int i = 0; i < points.length; i++)
      {
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
    } else if (value is List<num>) {
      setAttribute(POINTS, value);
    } else if (value is List<Position>) {
      List<num> ps = [];
      value.forEach((Position p) {
        ps.add(p.x);
        ps.add(p.y);
      });
      setAttribute(POINTS, ps);
    }
  }

  List<Position> get points {
    if (_points == null) {
      _points = [];
      var ps = getAttribute(POINTS);
      if (ps != null) {
        if (ps is String) {
          List<String> pss = ps.split(COMMA);
          for (int i = 0; i < pss.length; i += 2) {
            _points.add(new Position(x: double.parse(pss[i]), y: double.parse(pss[i + 1])));
          }
        } else if (ps is List<num>) {
          for (int i = 0; i < ps.length; i += 2) {
            _points.add(new Position(x: ps[i], y: ps[i+2]));
          }
        } else {
          _points.addAll(ps);
        }
      }
    }
    return _points;
  }

  String get pointsString => getAttribute(POINTS, '');

  num get x {
    _getBBox();
    return super.x + _bbox.x;
  }

  num get y {
    _getBBox();
    return super.y + _bbox.y;
  }

  num get width {
    _getBBox();
    return _bbox.width;
  }

  num get height {
    _getBBox();
    return _bbox.height;
  }
}
