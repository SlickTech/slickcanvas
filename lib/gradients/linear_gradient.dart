part of smartcanvas;

class LinearGradient extends Gradient {

  LinearGradient([Map<String, dynamic> config = const {}]) : super(config);

  @override
  Node _clone(Map<String, dynamic> config) => new LinearGradient(config);

  @override
  NodeImpl _createSvgImpl([bool isReflection = false]) => new SvgLinearGradient(this);

  @override
  NodeImpl _createCanvasImpl() => throw ExpNotImplemented;
}
