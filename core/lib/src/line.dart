import 'graph_node.dart';
import 'dart:math';

class Line extends GraphNode {
  Line([Map<String, dynamic> properties = const {}]) : super(properties);

  @override
  Line clone([Map<String, dynamic> propertiesOverride]) =>
      new Line(cloneProperties(propertiesOverride));

//  @override
//  NodeImpl _createSvgImpl([bool isReflection = false]) =>
//    new SvgLine(this, isReflection);
//
//  @override
//  NodeImpl _createCanvasImpl() => new CanvasLine(this);

  void set points(List<int> points) {
    assert(points.length >= 4);
    setProperty('x1', points[0]);
    setProperty('y1', points[1]);
    setProperty('x2', points[2]);
    setProperty('y2', points[3]);
  }

  List<int> get points => [
        getProperty('x1', 0),
        getProperty('y1', 0),
        getProperty('x2', 0),
        getProperty('y2', 0)
      ];

  void set x1(num value) => setProperty('x1', value);
  num get x1 => getProperty('x1', 0);

  void set y1(num value) => setProperty('y1', value);
  num get y1 => getProperty('y1', 0);

  void set x2(num value) => setProperty('x2', value);
  num get x2 => getProperty('x2', 0);

  void set y2(num value) => setProperty('y2', value);
  num get y2 => getProperty('y2', 0);

  @override
  BoundingBox get bbox {
    var pos = absolutePosition;
    return new BoundingBox(
        pos.x + min(x1, x2) * scaleX,
        pos.y + min(y1, y2) * scaleY - (strokeWidth / 2) * scaleY,
        (x1 - x2).abs() * scaleX,
        ((y1 - y2).abs() + strokeWidth) * scaleY);
  }
}
