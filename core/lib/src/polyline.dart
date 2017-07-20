import 'poly_shape.dart';
import 'position.dart';

class Polyline extends PolyShape {
  List<Position> _points = null;

  Polyline([Map<String, dynamic> properties = const {}]): super(properties);

  @override
  Polyline clone([Map<String, dynamic> propertiesOverride]) =>
      new Polyline(cloneProperties(propertiesOverride));

//  @override
//  NodeImpl _createSvgImpl([bool isReflection = false]) =>
//    new SvgPolyline(this, isReflection);
//
//  @override
//  NodeImpl _createCanvasImpl() => new CanvasPolyline(this);

  @override
  void set points(dynamic value) {
    if (value is List) {
      if (value.isNotEmpty) {
        if (value.first is num) {
          var ps = [];
          for (int i = 0; i < ps.length; i += 2) {
            ps.add(new Position(x: ps[i], y: ps[i + 1]));
          }
          setProperty('points', ps);
        } else if (value.first is Position) {
          setProperty('points', value);
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
      var ps = getProperty('points');
      if (ps != null) {
        if (ps is List) {
          if (ps.isNotEmpty) {
            if (ps.first is num) {
              for (int i = 0; i < ps.length; i += 2) {
                _points.add(new Position(x: ps[i], y: ps[i + 1]));
              }
            } else {
              _points.addAll(ps as List<Position>);
            }
          }
        }
      }
    }
    return _points;
  }

  @override
  String get pointsString {
    var rt = '';
    points.forEach((point) {
      rt += '${rt.length == 0 ? '' : ' '}${point.x},${point.y}';
    });
    return rt;
  }

  // Fill is always none
  @override
  void set fill(dynamic value) {}

  @override
  String get fill => 'none';
}
