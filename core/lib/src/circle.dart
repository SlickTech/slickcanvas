import 'graph_node.dart';

class Circle extends GraphNode {

  Circle([Map<String, dynamic> properties = const {}]) : super(properties) {
    var width = r * 2;
    setProperty('width', width);
    setProperty('height', width);
  }

  @override
  Circle clone([Map<String, dynamic> propertiesOverride]) =>
    new Circle(cloneProperties(propertiesOverride));

//  @override
//  NodeImpl _createSvgImpl([bool isReflection = false]) =>
//    new SvgCircle(this, isReflection);
//
//  @override
//  NodeImpl _createCanvasImpl() => new CanvasCircle(this);

  @override
  BoundingBox get bbox {
    var pos = absolutePosition;
    return new BoundingBox(
      pos.x - r * scaleX,
      pos.y - r * scaleY,
      width,
      height
    );
  }

  void set r(num value) => setProperty('r', value);
  num get r => getProperty('r', 0);

  @override
  num get width => r * 2 * scaleX;

  @override
  num get height => r * 2 * scaleY;
}
