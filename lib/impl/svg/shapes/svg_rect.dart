part of smartcanvas.svg;

class SvgRect extends SvgNode {
  SvgRect(Rect shell, bool isReflection): super(shell, isReflection);

  @override
  svg.SvgElement _createElement() => new svg.RectElement();

  @override
  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([X, Y, RX, RY, WIDTH, HEIGHT]);
    return attrs;
  }

  static const String _scRect = '__sc_rect';

  @override
  String get _nodeName => _scRect;
}
