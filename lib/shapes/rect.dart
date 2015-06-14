part of smartcanvas;

class Rect extends Node {
  Rect([Map<String, dynamic> config = const {}]) : super(config);

  @override
  Node _clone(Map<String, dynamic> config) => new Rect(config);

  @override
  NodeImpl _createSvgImpl([bool isReflection = false]) =>
    new SvgRect(this, isReflection);

  @override
  NodeImpl _createCanvasImpl() => new CanvasRect(this);

  void set rx(num value) => setAttribute(RX, value);

  num get rx => getAttribute(RX);

  void set ry(num value) => setAttribute(RY, value);

  num get ry => getAttribute(RY);
}
