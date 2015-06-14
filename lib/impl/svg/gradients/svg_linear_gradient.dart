part of smartcanvas.svg;

class SvgLinearGradient extends SvgGradient {
  SvgLinearGradient(LinearGradient shell) : super(shell);

  @override
  svg.SvgElement __createElement() => new svg.LinearGradientElement();

  @override
  Set<String> _getElementAttributeNames() {
    var rt = super._getElementAttributeNames();
    rt.addAll([X1, Y1, X2, Y2, SPREAD_METHOD]);
    return rt;
  }

  static const String _scLinearGradient = '__sc_linear_gradient';

  @override
  String get _nodeName => _scLinearGradient;
}
