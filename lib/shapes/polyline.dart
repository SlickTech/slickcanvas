part of smartcanvas;

class Polyline extends PolyShape {

  Polyline([Map<String, dynamic> config = const {}]): super(config) {
    setAttribute(FILL, 'none');
  }

  @override
  Node _clone(Map<String, dynamic> config) => new Polyline(config);

  @override
  NodeImpl _createSvgImpl([bool isReflection = false]) =>
    new SvgPolyline(this, isReflection);

  @override
  NodeImpl _createCanvasImpl() => new CanvasPolyline(this);

  @override
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

  @override
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

  @override
  String get pointsString {
    var rt = empty;
    points.forEach((point) {
      rt += '${rt.length == 0 ? empty : " "}${point.x},${point.y}';
    });
    return rt;
  }

  // Fill is always none
  @override
  void set fill(String value) => setAttribute(FILL, 'none');

  @override
  String get fill => 'none';
}
