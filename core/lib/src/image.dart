import 'graph_node.dart';

class Image extends GraphNode {
  Image([Map<String, dynamic> properties = const {}]): super(properties);

  @override
  Image clone([Map<String, dynamic> propertiesOverride]) =>
      new Image(cloneProperties(propertiesOverride));

//  @override
//  NodeImpl _createSvgImpl([bool isReflection = false]) =>
//    new SvgImage(this, isReflection);
//
//  @override
//  NodeImpl _createCanvasImpl() => new CanvasImage(this);

  void set href(String value) => setProperty('href', value);
  String get href => getProperty('href');
}
