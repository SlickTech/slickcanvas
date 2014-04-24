part of smartcanvas.svg;

class SvgLinearGradient extends SvgGradient {
  SvgLinearGradient(LinearGradient shell): super(shell) {}

  SVG.SvgElement __createElement() {
    return new SVG.LinearGradientElement();
  }

  String get _nodeName => SC_LINEAR_GRADIENT;
}