import 'graph_node.dart';

class Ellipse extends GraphNode {
  Ellipse([Map<String, dynamic> properties = const {}]) : super(properties);

  @override
  Ellipse clone([Map<String, dynamic> propertiesOverride]) =>
      new Ellipse(cloneProperties(propertiesOverride));
//
//  @override
//  NodeImpl _createSvgImpl([bool isReflection = false]) =>
//      new SvgEllipse(this, isReflection);
//
//  @override
//  NodeImpl _createCanvasImpl() => new CanvasEllipse(this);

  @override
  BoundingBox get bbox {
    var pos = absolutePosition;
    return new BoundingBox(pos.x - rx, pos.y - ry, width, height);
  }

  void set rx(num value) => setProperty('rx', value);
  num get rx => getProperty('rx', 0);

  void set ry(num value) => setProperty('ry', value);
  num get ry => getProperty('ry', 0);

  @override
  num get width => rx * matrix.scaleXValue;

  @override
  num get height => ry * matrix.scaleYValue;
}
