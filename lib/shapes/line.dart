part of smartcanvas;

class Line extends Node {
  Line(Map<String, dynamic> config): super(config) {}

  NodeImpl _createSvgImpl(bool isReflection) {
    return new SvgLine(this, isReflection);
  }

  NodeImpl _createCanvasImpl() {
    throw ExpNotImplemented;
  }

  void set points(List<num> points) {
    assert(points.length >= 4);
    setAttribute(X1, points[0]);
    setAttribute(Y1, points[1]);
    setAttribute(X2, points[2]);
    setAttribute(Y2, points[3]);
  }
  List<num> get points => [getAttribute(X1, 0), getAttribute(Y1, 0),
                           getAttribute(X2, 0), getAttribute(Y2, 0)];

  void set x1(num value) => setAttribute(X1, value);
  num get x1 => getAttribute(X1, 0);

  void set y1(num value) => setAttribute(Y1, value);
  num get y1 => getAttribute(Y1, 0);

  void set x2(num value) => setAttribute(X2, value);
  num get x2 => getAttribute(X2, 0);

  void set y2(num value) => setAttribute(Y2, value);
  num get y2 => getAttribute(Y2, 0);
}