part of smartcanvas.svg;

class SvgEllipse extends SvgNode{
  double rx;
  double ry;

  SvgEllipse(Ellipse shell, bool isReflection): super(shell, isReflection) {}

  SVG.SvgElement _createElement() {
    return new SVG.EllipseElement();
  }

  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([CX, CY, RX, RY]);
    return attrs;
  }

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

  String get _nodeName => SC_ELLIPSE;
}