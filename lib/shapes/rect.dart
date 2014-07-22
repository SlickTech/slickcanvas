part of smartcanvas;

class Rect extends Node {
  Rect(Map<String, dynamic> config): super(config) {}

  NodeImpl _createSvgImpl(bool isReflection) {
    return new SvgRect(this, isReflection);
  }

  NodeImpl _createCanvasImpl() {
    return new CanvasRect(this);
  }

  void set rx(num value) => setAttribute(RX, value);
  num get rx => getAttribute(RX);

  void set ry(num value) => setAttribute(RY, value);
  num get ry => getAttribute(RY);
}