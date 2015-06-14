part of smartcanvas;

class Polyline extends Node {
  BBox _bbox = null;
  List<Position> _points = null;

  Polyline([Map<String, dynamic> config = const {}]): super(config) {
    setAttribute(FILL, 'none');
    this
      ..on('translateXChanged translateYChanged', () => _bbox = null)
      ..on('pointsChanged', () {
      _bbox = null;
      _points = null;
    });
  }

  @override
  Node _clone(Map<String, dynamic> config) => new Polyline(config);

  @override
  NodeImpl _createSvgImpl([bool isReflection = false]) =>
    new SvgPolyline(this, isReflection);

  @override
  NodeImpl _createCanvasImpl() => new CanvasPolyline(this);

  void set points(dynamic value) {
    if (value is List) {
      if (value.isNotEmpty) {
        if (value.first is num) {
          var ps = [];
          for (int i = 0; i < ps.length; i += 2) {
            ps.add(new Position(x: ps[i], y: ps[i + 1]));
          }
          setAttribute(POINTS, ps);
        } else if (value.first is Position) {
          setAttribute(POINTS, value);
        } else {
          throw new Exception('Invalid parameter');
        }
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
        if (ps is List) {
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

  String get pointsString {
    var rt = empty;
    points.forEach((point) {
      rt += '${rt.length == 0 ? empty : " "}${point.x},${point.y}';
    });
    return rt;
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
      _bbox = new BBox(x: minX - halfStrokeWidth, y: minY - halfStrokeWidth,
      width: maxX - minX + strokeWidth + 20, height: maxY - minY + strokeWidth + 16);
    }
  }

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

  // Fill is always none
  @override
  void set fill(String value) => setAttribute(FILL, 'none');

  @override
  String get fill => 'none';
}
