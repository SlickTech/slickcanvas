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

  NodeImpl _createSvgImpl(bool isReflection) {
    return new SvgCircle(this, isReflection);
  }

  NodeImpl _createCanvasImpl() {
    throw ExpNotImplemented;
  }

  BBox getBBox(bool isAbsolute) {
    Position pos = isAbsolute ? this.absolutePosition : this.position;
    return new BBox(x: pos.x - r, y: pos.y - r, width: this.width, height: this.height);
  }

  void set r(num value) => setAttribute(R, value);
  num get r => getAttribute(R);
}