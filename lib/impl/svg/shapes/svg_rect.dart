part of smartcanvas.svg;

class SvgRect extends SvgNode {
  SvgRect(Rect shell, bool isReflection): super(shell, isReflection) {}

  SVG.SvgElement _createElement() {
    return new SVG.RectElement();
  }

  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll(['x', 'y', 'rx', 'ry', 'width', 'height']);
    return attrs;
  }

  String get _nodeName => SC_RECT;
}