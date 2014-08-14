part of smartcanvas;

class Polygon extends Node{
  BBox _bbox = null;
  List<Position> _points = null;

  Polygon(Map<String, dynamic> config): super(config) {
    this.on('pointsChanged', () { _bbox = null; _points = null; });
  }

  NodeImpl _createSvgImpl(bool isReflection) {
    return new SvgPolygon(this, isReflection);
  }

  NodeImpl _createCanvasImpl() {
    return new CanvasPolygon(this);
  }

  BBox getBBox(bool isAbsolute) {
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
      _bbox = new BBox(x: minX, y: minY, width: maxX - minX, height: maxY - minY);
    }
    return new BBox(x: this.x + _bbox.x, y: this.y + _bbox.y, width: _bbox.width, height: _bbox.height);
  }

  void set points(dynamic value) {
    if (value is String) {
      setAttribute(POINTS, value);
    } else if (value is List<num>) {
      setAttribute(POINTS, value.join(COMMA));
    } else if (value is List<Position>) {
      List<num> ps = [];
      value.forEach((Position p) {
        ps.add(p.x);
        ps.add(p.y);
      });
      setAttribute(POINTS, ps.join(COMMA));
    }
  }

  List<Position> get points {
    if (_points == null) {
      _points = [];
      String ps = getAttribute(POINTS);
      if (ps != null) {
        List<String> pss = ps.split(COMMA);
        for (int i = 0; i < pss.length; i += 2) {
          _points.add(new Position(x: double.parse(pss[i]), y: double.parse(pss[i + 1])));
        }
      }
    }
    return _points;
  }

  String get pointsString => getAttribute(POINTS, '');

  num get width {
    var bbox = getBBox(true);
    return bbox.right;
  }

  num get height {
    var bbox = getBBox(true);
    return bbox.bottom;
  }
}
