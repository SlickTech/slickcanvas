part of smartcanvas.svg;

class SvgRadialGradient extends SvgGradient {
  SvgRadialGradient(RadialGradient shell): super(shell) {}

  SVG.SvgElement __createElement() {
    return new SVG.RadialGradientElement();
  }

  Set<String> _getElementAttributeNames() {
    var rt = super._getElementAttributeNames();
    rt.addAll([CX, CY, R, FX, FY, SPREAD_METHOD]);
    return rt;
  }

  String get _nodeName => SC_RADIAL_GRADIENT;
}