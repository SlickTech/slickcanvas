part of smartcanvas;

class Rect extends Node {
  Rect(Map<String, dynamic> config): super(config) {}

  NodeImpl _createSvgImpl(bool isReflection) {
    return new SvgRect(this, isReflection);
  }

  NodeImpl _createCanvasImpl() {
    throw ExpNotImplemented;
  }
}