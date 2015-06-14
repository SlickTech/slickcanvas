part of smartcanvas;

class RadialGradient extends Gradient {
  RadialGradient([Map<String, dynamic> config = const {}]) : super(config);

  @override
  Node _clone(Map<String, dynamic> config) => new RadialGradient(config);

  @override
  NodeImpl _createSvgImpl([bool isReflection = false]) => new SvgRadialGradient(this);

  @override
  NodeImpl _createCanvasImpl() => throw ExpNotImplemented;
}
