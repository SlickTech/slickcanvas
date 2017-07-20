import 'poly_shape.dart';
import 'position.dart';

class Polygon extends PolyShape {
  List<Position> _points = null;

  Polygon([Map<String, dynamic> prop = const {}]) : super(prop);

  @override
  Polygon clone([Map<String, dynamic> propertiesOverride]) =>
      new Polygon(cloneProperties(propertiesOverride));

//  @override
//  NodeImpl _createSvgImpl([bool isReflection = false]) =>
//    new SvgPolygon(this, isReflection);
//
//  @override
//  NodeImpl _createCanvasImpl() => new CanvasPolygon(this);

  @override
  void set points(dynamic value) {
    if (value is String) {
      setProperty('points', value);
    } else if (value is List) {
      if (value.isNotEmpty) {
        if (value.first is num) {
          StringBuffer sb;
          sb.writeAll(value, ',');
          setProperty('points', sb.toString());
        } else if (value.first is Position) {
          var ps = [];
          for (Position p in value) {
            ps.add(p.x);
            ps.add(p.y);
          }
          StringBuffer sb;
          sb.writeAll(ps, ',');
          setProperty('points', sb.toString());
        } else {
          throw new Exception('Invalid parameter');
        }
      }
    } else {
      throw new Exception('Invalid parameter');
    }
    _points = null;
  }

  @override
  List<Position> get points {
    if (_points == null) {
      _points = [];
      var ps = getProperty('points');
      var pss = ps.split(',');
      for (int i = 0; i < pss.length; i += 2) {
        _points.add(new Position(x: num.parse(pss[i]), y: num.parse(pss[i + 1])));
      }
    }
    return _points;
  }

  String get pointsString => getProperty('points', '');
}
