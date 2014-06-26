part of smartcanvas.svg;

class SvgLinearGradient extends SvgGradient {
  SvgLinearGradient(LinearGradient shell): super(shell) {}

  SVG.SvgElement __createElement() {
    return new SVG.LinearGradientElement();
  }

  Set<String> _getElementAttributeNames() {
    var rt = super._getElementAttributeNames();
    rt.addAll([X1, Y1, X2, Y2, SPREAD_METHOD]);
    return rt;
  }

  String get _nodeName => SC_LINEAR_GRADIENT;
}