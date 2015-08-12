part of smartcanvas;

class Circle extends Node {

  Circle([Map<String, dynamic> config = const {}]) : super(config);

  @override
  Node _clone(Map<String, dynamic> config) => new Circle(config);

  @override
  void _populateConfig() {
    super._populateConfig();
    var r = attrs[R];
    if (r == null) {
      r = attrs[R] = 0;
    }
    var width = r * 2;
    setAttribute(WIDTH, width);
    setAttribute(HEIGHT, width);
  }

  @override
  NodeImpl _createSvgImpl([bool isReflection = false]) =>
    new SvgCircle(this, isReflection);

  @override
  NodeImpl _createCanvasImpl() => new CanvasCircle(this);

  @override
  BBox getBBox(bool isAbsolute) {
    var pos = isAbsolute ? this.absolutePosition : this.position;
    return new BBox(
      x: pos.x - r,
      y: pos.y - r,
      width: this.actualWidth,
      height: this.actualHeight
    );
  }

  void set r(num value) => setAttribute(R, value);
  num get r => getAttribute(R);
}
