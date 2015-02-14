part of smartcanvas;

class RadialGradient extends Gradient {
  RadialGradient(Map<String, dynamic> config): super(config) {}

  NodeImpl _createSvgImpl([bool isReflection = false]) {
    return new SvgRadialGradient(this);
  }

  NodeImpl _createCanvasImpl() {
    throw ExpNotImplemented;
  }
}