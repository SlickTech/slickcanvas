part of smartcanvas.svg;

class SvgRadialGradient extends SvgGradient {
  SvgRadialGradient(RadialGradient shell) : super(shell);

  @override
  svg.SvgElement __createElement() => new svg.RadialGradientElement();

  @override
  Set<String> _getElementAttributeNames() {
    var rt = super._getElementAttributeNames();
    rt.addAll([CX, CY, R, FX, FY, SPREAD_METHOD]);
    return rt;
  }

  static const String _scRadialGradient = '__sc_radial_gradient';

  @override
  String get _nodeName => _scRadialGradient;
}
