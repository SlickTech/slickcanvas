part of smartcanvas;

class Circle extends Node {

  Circle(Map<String, dynamic> config): super(config) {}

  void populateConfig() {
    super.populateConfig();
    num r = _attrs[R];
    if (r == null) {
      r = _attrs[R] = 0;
    }
    var width = r * 2;
    setAttribute(WIDTH, width);
    setAttribute(HEIGHT, width);
  }

  NodeImpl _createSvgImpl() {
    return new SvgCircle(this);
  }

  NodeImpl _createCanvasImpl() {
    throw ExpNotImplemented;
  }

  void set r(num value) => setAttribute(R, value);
  num get r => getAttribute(R);
}