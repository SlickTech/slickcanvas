part of smartcanvas;

class Path extends Node {
  Path(Map<String, dynamic> config): super(config) {}

  NodeImpl _createSvgImpl(bool isReflection) {
    return new SvgPath(this, isReflection);
  }

  NodeImpl _createCanvasImpl() {
    throw ExpNotImplemented;
  }

  void set d(String value) => setAttribute(D, value);
  String get d => getAttribute(D);
}