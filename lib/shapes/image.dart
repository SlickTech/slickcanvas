part of smartcanvas;

class Image extends Node {
  Image([Map<String, dynamic> config = const {}]): super(config);

  @override
  Node _clone(Map<String, dynamic> config) => new Image(config);

  @override
  NodeImpl _createSvgImpl([bool isReflection = false]) =>
    new SvgImage(this, isReflection);

  @override
  NodeImpl _createCanvasImpl() => new CanvasImage(this);

  void set href(String value) => setAttribute(HREF, value);
  String get href => getAttribute(HREF);
}
