part of smartcanvas;

class LinearGradient extends Gradient {

  LinearGradient(Map<String, dynamic> config): super(config) {}

  NodeImpl _createSvgImpl() {
    return new SvgLinearGradient(this);
  }

  NodeImpl _createCanvasImpl() {
    throw ExpNotImplemented;
  }

}