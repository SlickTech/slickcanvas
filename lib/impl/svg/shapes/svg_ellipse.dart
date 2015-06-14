part of smartcanvas.svg;

class SvgEllipse extends SvgNode {

  SvgEllipse(Ellipse shell, bool isReflection) : super(shell, isReflection);

  @override
  svg.SvgElement _createElement() => new svg.EllipseElement();

  @override
  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([CX, CY, RX, RY]);
    return attrs;
  }

  @override
  dynamic getAttribute(String attr, [dynamic defaultValue = null]) {
    switch (attr) {
      case CX:
        return super.getAttribute(X, defaultValue);
      case CY:
        return super.getAttribute(Y, defaultValue);
      default:
        return super.getAttribute(attr, defaultValue);
    }
  }

  static const String _scEllipse = '__sc_ellipse';

  @override
  String get _nodeName => _scEllipse;
}
