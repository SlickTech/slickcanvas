part of smartcanvas;

class Ellipse extends Node {

  Ellipse(Map<String, dynamic> config): super(config) {}

  NodeImpl _createSvgImpl() {
    return new SvgEllipse(this);
  }

  NodeImpl _createCanvasImpl() {
    throw ExpNotImplemented;
  }

  BBox getBBox(bool isAbsolute) {
    Position pos = isAbsolute ? this.absolutePosition : this.position;
    return new BBox(x: pos.x - rx, y: pos.y - ry, width: this.width, height: this.height);
  }

  void set rx(num value) => setAttribute(RX, value);
  num get rx => getAttribute(RX);

  void set ry(num value) => setAttribute(RY, value);
  num get ry => getAttribute(RY);

  num get width => rx * 2;
  num get height => ry * 2;
}