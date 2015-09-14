part of smartcanvas;

class Polygon extends PolyShape {

  Polygon([Map<String, dynamic> config = const {}]) : super(config);

  @override
  Node _clone(Map<String, dynamic> config) => new Polygon(config);

  @override
  NodeImpl _createSvgImpl([bool isReflection = false]) =>
    new SvgPolygon(this, isReflection);

  @override
  NodeImpl _createCanvasImpl() => new CanvasPolygon(this);

  @override
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

  @override
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
}
