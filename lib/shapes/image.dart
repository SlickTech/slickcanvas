part of smartcanvas;

class Image extends Node {
  Image(Map<String, dynamic> config): super(config) {}

  NodeImpl _createSvgImpl([bool isReflection = false]) {
    return new SvgImage(this, isReflection);
  }

  NodeImpl _createCanvasImpl() {
    throw 'NotImplemented';
//      return new CanvasImage(this);
  }

  void set href(String value) => setAttribute(HREF, value);
  String get href => getAttribute(HREF);
}