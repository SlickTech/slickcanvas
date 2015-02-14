part of smartcanvas;

class Polyline extends Node {
  BBox _bbox = null;
  List<Position> _points = null;

  Polyline(Map<String, dynamic> config): super(config) {
    setAttribute(FILL, 'none');
    this.on('translateXChanged translateYChanged', () => _bbox = null);
    this.on('pointsChanged', () { _bbox = null; _points = null; });
  }

  NodeImpl _createSvgImpl([bool isReflection = false]) {
    return new SvgPolyline(this, isReflection);
  }

  NodeImpl _createCanvasImpl() {
    return new CanvasPolyline(this);
  }

  void set points(dynamic value) {
    if (value is List<num>) {
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
      var ps = getAttribute(POINTS);

      if (ps != null) {
        if (ps is List<num>) {
          for (int i = 0; i < ps.length; i += 2) {
            _points.add(new Position(x: ps[i], y: ps[i+1]));
          }
        } else {
          _points.addAll(ps);
        }
      }
    }
    return _points;
  }

  String get pointsString {
    String rt = EMPTY;
    points.forEach((point) {
      rt += '${rt.length == 0 ? "" : " "}${point.x},${point.y}';
    });
    return rt;
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
      num halfStrokeWidth = strokeWidth / 2 + 10;
      _bbox = new BBox(x: minX - halfStrokeWidth, y: minY - halfStrokeWidth,
          width: maxX - minX + strokeWidth + 20, height: maxY - minY + strokeWidth + 16);
    }
  }

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

  Position get origin {
    return new Position(x: super.x, y: super.y);
  }

  // Fill is always none
  void set fill(String value) => setAttribute(FILL, 'none');
  String get fill => 'none';
}