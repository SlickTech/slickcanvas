part of smartcanvas;

class Ellipse extends Node {

  Ellipse([Map<String, dynamic> config = const {}]): super(config);

  @override
  Node _clone(Map<String, dynamic> config) => new Ellipse(config);

  @override
  NodeImpl _createSvgImpl([bool isReflection = false]) =>
    new SvgEllipse(this, isReflection);

  @override
  NodeImpl _createCanvasImpl() => new CanvasEllipse(this);

  @override
  BBox getBBox(bool isAbsolute) {
    var pos = isAbsolute ? this.absolutePosition : this.position;
    return new BBox(
      x: pos.x - rx,
      y: pos.y - ry,
      width: this.actualWidth,
      height: this.actualHeight
    );
  }

  void set rx(num value) => setAttribute(RX, value);
  num get rx => getAttribute(RX);

  void set ry(num value) => setAttribute(RY, value);
  num get ry => getAttribute(RY);

  @override
  num get width => rx * 2;

  @override
  num get height => ry * 2;
}
