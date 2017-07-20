import 'graph_node.dart';
import 'dart:math';

//import 'package:meta/meta.dart';

abstract class PolyShape extends GraphNode {
//  @protected
  BoundingBox _bbox = null;

//  @protected
//  List<Position> _points = null;

  PolyShape([Map<String, dynamic> props = const {}]) : super(props) {
    properties.changes.listen((changes) {
      for (MapChangeRecord<String, dynamic> change in changes) {
        if (change.key == 'points' || change.key == 'matrix') {
          _bbox = null;
        }
      }
    });
  }

  @override
  BoundingBox get bbox {
    _getBBox();
    var pos = absolutePosition;
    return new BoundingBox(
        pos.x + _bbox.x, pos.y + _bbox.y, _bbox.width, _bbox.height);
  }

  BoundingBox _getBBox() {
    if (_bbox == null) {
      var points = this.points;
      var minX = double.MAX_FINITE;
      var maxX = -double.MAX_FINITE;
      var minY = double.MAX_FINITE;
      var maxY = -double.MAX_FINITE;
      for (int i = 0; i < points.length; i++) {
        minX = min(minX, points[i].x as double);
        maxX = max(maxX, points[i].x as double);
        minY = min(minY, points[i].y as double);
        maxY = max(maxY, points[i].y as double);
      }
      _bbox = new BoundingBox(
          minX, minY, (maxX - minX) * scaleX, (maxY - minY) * scaleY);
    }
    return _bbox;
  }

  void set points(dynamic value);
  List<Position> get points;

  String get pointsString;

  @override
  int get x => (super.x + _getBBox().x).toInt();

  @override
  int get y => (super.y + _getBBox().y).toInt();

  @override
  num get width => _getBBox().width;

  @override
  num get height => _getBBox().height;

  Position get origin {
    return new Position(x: super.x, y: super.y);
  }
}
