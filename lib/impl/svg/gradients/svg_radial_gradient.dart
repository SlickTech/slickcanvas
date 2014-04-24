part of smartcanvas.svg;

class SvgRadialGradient extends SvgGradient {
  SvgRadialGradient(RadialGradient shell): super(shell) {}

  SVG.SvgElement __createElement() {
    return new SVG.RadialGradientElement();
  }

  String get _nodeName => SC_RADIAL_GRADIENT;
}