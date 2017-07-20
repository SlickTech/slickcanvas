import "graph_node.dart";

class Rect extends GraphNode {
  Rect([Map<String, dynamic> properties = const {}]) : super(properties);

  @override
  Rect clone([Map<String, dynamic> propertiesOverride = const {}]) =>
      new Rect(cloneProperties(propertiesOverride));

//  @override
//  Node clone([Map<String, dynamic> propOverride]) =>
//      new Rect(cloneProperty(propOverride));

//  @override
//  NodeImpl _createSvgImpl([bool isReflection = false]) =>
//    new SvgRect(this, isReflection);
//
//  @override
//  NodeImpl _createCanvasImpl() => new CanvasRect(this);

  void set rx(num value) => setProperty('rx', value);

  num get rx => getProperty('rx');

  void set ry(num value) => setProperty('ry', value);

  num get ry => getProperty('ry');

  @override
  num get width => getProperty('width', 0) * scaleX;

  @override
  num get height => getProperty('height', 0) * scaleY;
}
